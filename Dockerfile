FROM eclipse-temurin:17-jre

WORKDIR /home/internal

# creating unprivileged user
RUN groupadd --gid 1000 internal \
    && useradd --uid 1000 --gid internal --shell /bin/bash --home-dir /home/internal internal \
    && chown internal:internal .

COPY --chown=internal:internal entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

VOLUME /certs

ENTRYPOINT [ "./entrypoint.sh" ]