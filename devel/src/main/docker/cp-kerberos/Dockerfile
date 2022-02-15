ARG UPSTREAM_REPOSITORY=docker.io
ARG VERSION

FROM --platform=${BUILDPLATFORM} ${UPSTREAM_REPOSITORY}/jackcviers/cp-base-new:${VERSION}

USER root

#USE /var/run/krb5/ mounted as a volume for hosting these files
ENV KRB5_CONFIG=/etc/krb5.conf
#USE /var/run/krb5/ mounted as a volume for hosting these files
ENV KRB5_KDC_PROFILE=/etc/krb5kdc/kdc.conf

ADD --chown=root:root ./include/etc/krb5kdc/kadm5.acl /etc/krb5kdc/kadm5.acl
ADD --chown=root:root --chmod=750 ./include/write-krb5-conf.sh /write-krb5-conf.sh
ADD --chown=root:root ./include/etc/krb5kdc/kdc.conf /etc/krb5kdc/kdc.conf
ADD --chown=root:root --chmod=750 ./include/run.sh /run.sh
ADD --chown=root:root --chmod=750 ./include/add-admin.sh /add-admin.sh

RUN apt-get update -y  && apt-get upgrade -y  && apt-get install -y krb5-kdc krb5-admin-server krb5-config && kdb5_util create -P masterkey -r TEST.CONFLUENT.IO -s && /write-krb5-conf.sh && /add-admin.sh && mkdir -p /var/run/krb5/keytabs

VOLUME [ "/var/run/krb5" ]

ENTRYPOINT [ "/run.sh" ]
