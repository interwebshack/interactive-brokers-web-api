[![License: Apache 2.0](https://img.shields.io/crates/l/apa)](https://opensource.org/license/mit/)

# Interactive Brokers Web API
  
A docker container and flask app for use with the [Interactive Brokers Web API 1.0](https://ibkrcampus.com/campus/ibkr-api-page/webapi-doc/)  
  
>**_NOTE:_**This project is still under active development, watch for tagged releases.  
  
## Requirements

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Podman Desktop](https://podman-desktop.io/)

## Clone The Source Code
```
git clone https://github.com/interwebshack/interactive-brokers-web-api.git
```

## Installation  
To install the app with all dependencies:
```
poetry install
```

## Export `requirements.txt` File For Container Build  
```
poetry export --without-hashes --format=requirements.txt > requirements.txt
```

## Run Tests with Coverage  
```
pytest --cov=ib_rest_api --cov-report=term-missing
```

## Build The Container  
```
podman build -t ibkr-rest-api:0.1.0 .
```

## Bring Up The Container  
```
podman run --rm --name ibkr -e IBKR_ACCOUNT_ID=U1234567 -p 5055:5055 -p 5056:5056 ibkr-rest-api:0.1.0
```

## Project Structure

```shell
interactive-brokers-web-api/
├── ib_gateway/
│   └── conf.yaml
├── ib_rest_api/
│   ├── __init__.py
│   ├── app.py
│   ├── config.py
│   └── routes.py
├── tests/
│   ├── __init__.py
│   └── test_routes.py
├── .gitignore          # Git ignore rules
├── Dockerfile          # Docker build script
├── LICENSE             # Project license
├── pyproject.toml
├── README.md           # Project docs
├── requirements-dev.txt
└── requirements.txt
```

## License

MIT (See [LICENSE](./LICENSE))

## Acknowledgements

This project is heavily inspired by the following projects: 
* [interactive-brokers-web-api](https://github.com/hackingthemarkets/interactive-brokers-web-api)  
* [iBeam](https://github.com/Voyz/ibeam)  
* [iBind](https://github.com/Voyz/ibind)  
