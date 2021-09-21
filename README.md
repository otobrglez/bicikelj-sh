# bicikelj.sh

This is [BicikeLJ][BicikeLJ] client implemented in [Bash].

Usage:

```bash
./bicikelj.sh
./bicikelj.sh "Dunajska 5, 1000 Ljubljana"
```

The output will show 3 nearest stations that have bikes available. I.e.

```json
[
  {
    "name": "PREŠERNOV TRG-PETKOVŠKOVO NABREŽJE",
    "free": 13,
    "latitude": 46.051380037071965,
    "longitude": 14.506524332086412,
    "distance": 42.969
  },
  {
    "name": "POGAČARJEV TRG-TRŽNICA",
    "free": 13,
    "latitude": 46.05110603801571,
    "longitude": 14.507168331524257,
    "distance": 99.135
  },
  {
    "name": "KONGRESNI TRG-ŠUBIČEVA ULICA",
    "free": 14,
    "latitude": 46.05040103728995,
    "longitude": 14.504605334359988,
    "distance": 155.301
  }
]
```

### Capabilities

- Gets the nearest BicikeLJ bicycle stations that has free bicycles. Location is extracted from your IP address.
- Gets the nearest stations for particular location - expressed in text. 

### Web Services and APIs

- Location is extracted from your IP address with the help of [ipstack] API
- Forward geocoding service is done with [positionstack] API.
- BicikeLJ information is provided by [Ljubljana PromInfo](https://prominfo.projekti.si/web/)

### Dependencies

This script depends on the following tools: [jq], [curl]
and standard toolset with `bc`, `echo`, `cat` and `sed`.

## Development

```bash
ls *.sh | entr ./bicikelj.sh "Ljubljana Dunajska 5"
```

## Author

- [Oto Brglez](https://github.com/otobrglez)


[BicikeLJ]: https://www.bicikelj.si
[Bash]: https://www.gnu.org/software/bash/
[jq]: https://stedolan.github.io/jq/
[curl]: https://curl.se/
[ipstack]: https://ipstack.com
[positionstack]:https://positionstack.com/
