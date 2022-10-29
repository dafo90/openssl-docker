FROM alpine

RUN apk --update add openssl

ENTRYPOINT ["openssl"]