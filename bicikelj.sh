#!/usr/bin/env bash
# ~~~~ Bicikelj.sh ~~~~~
# @otobrglez - <otobrglez@gmail.com>

set -e
set -o pipefail

deg2rad() { bc -l <<<"$1 * 0.0174532925"; }
rad2deg() { bc -l <<<"$1 * 57.2957795"; }
acos() { bc -l <<<"3.141592653589793 / 2 - a($1 / sqrt(1 - $1 * $1))"; }

distance() {
  lat_1="$1"
  lon_1="$2"
  lat_2="$3"
  lon_2="$4"
  delta_lat=$(bc <<<"$lat_2 - $lat_1")
  delta_lon=$(bc <<<"$lon_2 - $lon_1")
  lat_1="$(deg2rad $lat_1)"
  lon_1="$(deg2rad $lon_1)"
  lat_2="$(deg2rad $lat_2)"
  lon_2="$(deg2rad $lon_2)"
  delta_lat="$(deg2rad $delta_lat)"
  delta_lon="$(deg2rad $delta_lon)"
  distance=$(bc -l <<<"s($lat_1) * s($lat_2) + c($lat_1) * c($lat_2) * c($delta_lon)")
  distance=$(acos $distance)
  distance="$(rad2deg $distance)"
  distance=$(bc -l <<<"$distance * 60 * 1.15078")
  distance=$(bc <<<"scale=4; $distance / 1")
  distance=$(bc <<<"scale=2; $distance * 1.609344 * 1000")
  echo $distance
}

geo_access_token() { echo "3069cb037d9f02837a5f858c10db2c04"; }
geocode_access_token() { echo "d1948667bb6401cbafedf7bc70c07d2b"; }
current_ip() { curl -s -4 https://icanhazip.com; }

ip_for_location() {
  curl -s "http://api.ipstack.com/$1?access_key=$(geo_access_token)&output=json" |
    jq -cr "[.latitude,.longitude]" | cat | tr '[] ' " " | sed 's/ *$//g' | sed "s/ //1"
}

text_to_location() {
  curl -G -s \
    --data-urlencode "query=$1" \
    "http://api.positionstack.com/v1/forward?access_key=$(geocode_access_token)" |
    jq -cr ".data[0]|[.latitude,.longitude]" | cat | tr '[] ' " " | sed 's/ *$//g' | sed "s/ //1"
}

get_stations() {
  geometry='{"xmin":14.0321,"ymin":45.7881,"xmax":14.8499,"ymax":46.218,"spatialReference":{"wkid":4326}}'
  curl -G \
    --data-urlencode "f=json" \
    --data-urlencode "returnGeometry=true" \
    --data-urlencode "outSr=4326" \
    --data-urlencode "geometry=$geometry}" \
    --data-urlencode "outFields=*" \
    -s --insecure 'https://prominfo.projekti.si/web/api/MapService/Query/lay_bicikelj/query'
}

source_location() {
  # shellcheck disable=SC2046
  if [ "$1" != "" ]; then text_to_location "$1"; else ip_for_location $(current_ip); fi
}

stations_list() {
  get_stations |
    jq -c ".features[]|[.geometry.y,.geometry.x,.attributes.bike_stand_free,.attributes.name]| select(.[2] != 0)" |
    cat | sed 's/ *$//g' | tr '[] ' " " | sed "s/ //1"
}

# --- main ---
query=$1
current_location=$(source_location "$query")

stations_list | while IFS=',' read LINE; do
  current_latitude=$(echo "$current_location" | cut -d "," -f 1)
  current_longitude=$(echo "$current_location" | cut -d "," -f 2)
  latitude=$(echo "$LINE" | cut -d "," -f 1)
  longitude=$(echo "$LINE" | cut -d "," -f 2)
  free=$(echo "$LINE" | cut -d "," -f 3)
  name=$(echo "$LINE" | cut -d "," -f 4 | tr -d '"')

  distance=$(distance $latitude $longitude $current_latitude $current_longitude)
  # shellcheck disable=SC2046
  echo $(jq -c -n \
    --arg latitude "$latitude" \
    --arg longitude "$longitude" \
    --arg distance "$distance" \
    --arg name "$name" \
    --arg free $free \
    '{name:$name, free: $free|tonumber, latitude: $latitude|tonumber, longitude: $longitude|tonumber, distance: $distance|tonumber}')
done |
  jq -s '.|sort_by(.distance, .free)|.[0:3]'
