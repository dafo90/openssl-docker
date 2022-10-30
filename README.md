# OpenSSL Docker

Simple OpenSSL Docker container.

## Docker compose (example)

```
version: '3.9'

services:
  openssl:
    image: dafo90/openssl
    volumes:
      - ./certs:/certs
    environment:
      DAYS: 3650
      PASSWORD: "pass:MySuperSecretPassword"
      KEYSTORE: keystoreFileName
      PRIVATE_KEY_NAME: privateKeyName
      KEYSTORE_TYPE: JKS
```
