# OpenSSL Docker

Simple OpenSSL Docker container running in Alpine Linux

## Usage

```
docker run -ti --rm -v $(pwd):/certs -w /certs dafo90/openssl <openssl_command>
```
