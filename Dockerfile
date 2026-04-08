FROM quay.io/keycloak/keycloak:latest AS builder

ENV KC_DB=postgres
RUN /opt/keycloak/bin/kc.sh build --db=postgres

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENV KC_HTTP_RELATIVE_PATH=/auth
ENV KC_HTTP_ENABLED=true
ENV KC_HTTP_PORT=8443
ENV KC_HTTPS_PORT=8444
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME_STRICT_HTTPS=false
ENV KC_PROXY=passthrough
ENV KC_PROXY_HEADERS=xforwarded
ENV PROXY_ADDRESS_FORWARDING=true
ENV KC_LOG_LEVEL=INFO

EXPOSE 8443
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--db=postgres"]
