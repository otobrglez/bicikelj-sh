# bicikelj.sh

This is [BicikeLJ][BicikeLJ] client implemented in [Bash].

Capabilities:

- Get nearest BicikeLJ stations that have free bicycles. Location is extracted from your IP address. with the helo of .
- Get nearest stations for perticular location - expressed in text. 


Web Services and APIs
- Location is extracted from your IP address with the help of [ipstack] API
- Forward geocoding service is done with [positionstack] API.
- BicikeLJ information is provided by [Ljubljana PromInfo](https://prominfo.projekti.si/web/)

- [Oto Brglez](https://github.com/otobrglez)

This script depends on the following tools: [jq], [curl]
and standard toolset with `bc`, `echo`, `cat` and `sed`.

## Development

```bash
ls *.sh | entr ./bicikelj.sh "Ljubljana Dunajska 5"
```

[BicikeLJ]: https://www.bicikelj.si
[Bash]: https://www.gnu.org/software/bash/
[jq]: https://stedolan.github.io/jq/
[curl]: https://curl.se/
[ipstack]: https://ipstack.com
[positionstack]:https://positionstack.com/
