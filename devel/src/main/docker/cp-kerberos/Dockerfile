ARG UPSTREAM_REPOSITORY=docker.io
ARG VERSION

FROM --platform=${BUILDPLATFORM} ${UPSTREAM_REPOSITORY}/jackcviers/cp-base-new:${VERSION}

USER root

RUN apt install -y krb5-kdc krb5-admin-server krb5-config -y

EXPOSE 88 749

ADD ./config.sh /config.sh

ENTRYPOINT ["/config.sh"]
