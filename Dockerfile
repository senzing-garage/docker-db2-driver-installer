ARG BASE_IMAGE=debian:11.6-slim@sha256:7acda01e55b086181a6fa596941503648e423091ca563258e2c1657d140355b1

# -----------------------------------------------------------------------------
# Stage: db2_builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} as db2_builder

ENV REFRESHED_AT=2023-04-03

LABEL Name="senzing/senzing-db2-builder" \
      Version="1.0.4"

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      unzip

# Copy the DB2 ODBC client code.
# The tar.gz files must be independently downloaded before the docker build.

ADD ./downloads/ibm_data_server_driver_for_odbc_cli_linuxx64_v11.1.tar.gz /opt/IBM/db2
ADD ./downloads/v11.1.4fp4a_jdbc_sqlj.tar.gz /tmp/db2-jdbc-sqlj

# Extract ZIP file.

RUN unzip -d /tmp/extracted-jdbc /tmp/db2-jdbc-sqlj/jdbc_sqlj/db2_db2driver_for_jdbc_sqlj.zip

# -----------------------------------------------------------------------------
# Final stage
# -----------------------------------------------------------------------------

ARG BASE_IMAGE=debian:11.6-slim@sha256:7acda01e55b086181a6fa596941503648e423091ca563258e2c1657d140355b1
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2023-04-03

LABEL Name="senzing/db2-driver-installer" \
      Maintainer="support@senzing.com" \
      Version="1.0.4"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

USER root

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      python-dev \
 && rm -rf /var/lib/apt/lists/*

# Copy files from repository.

COPY ./rootfs /
COPY ./db2-driver-installer.py /app/

# Copy files from "db2_builder" stage.

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/adm/db2trc", \
    "/opt/IBM-template/db2/clidriver/adm/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/bin/db2dsdcfgfill", \
    "/opt/IBM/db2/clidriver/bin/db2ldcfg", \
    "/opt/IBM/db2/clidriver/bin/db2lddrg", \
    "/opt/IBM/db2/clidriver/bin/db2level", \
    "/opt/IBM-template/db2/clidriver/bin/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/cfg/db2cli.ini.sample", \
    "/opt/IBM/db2/clidriver/cfg/db2dsdriver.cfg.sample", \
    "/opt/IBM/db2/clidriver/cfg/db2dsdriver.xsd", \
    "/opt/IBM-template/db2/clidriver/cfg/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/conv/alt/08501252.cnv", \
    "/opt/IBM/db2/clidriver/conv/alt/12520850.cnv", \
    "/opt/IBM/db2/clidriver/conv/alt/IBM00850.ucs", \
    "/opt/IBM/db2/clidriver/conv/alt/IBM01252.ucs", \
    "/opt/IBM-template/db2/clidriver/conv/alt/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/include/sqlcli1.h", \
    "/opt/IBM/db2/clidriver/include/sqlsystm.h", \
    "/opt/IBM/db2/clidriver/include/sqlca.h", \
    "/opt/IBM/db2/clidriver/include/sqlcli.h", \
    "/opt/IBM/db2/clidriver/include/sql.h", \
    "/opt/IBM-template/db2/clidriver/include/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/lib/libdb2.so.1", \
    "/opt/IBM/db2/clidriver/lib/libdb2o.so.1", \
    "/opt/IBM-template/db2/clidriver/lib/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8cms_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8iccs_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8km_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8ssl_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8sys_64.so", \
    "/opt/IBM-template/db2/clidriver/lib/icc/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/ICCSIG.txt", \
    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/libicclib084.so", \
    "/opt/IBM-template/db2/clidriver/lib/icc/C/icc/icclib/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2admh.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2adm.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clia1.lst", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clias.lst", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clih.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2cli.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clit.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clp.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2diag.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2sqlh.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2sql.mo", \
    "/opt/IBM-template/db2/clidriver/msg/en_US.iso88591/" \
    ]

COPY --from=db2_builder [ \
    "/tmp/extracted-jdbc/db2jcc.jar", \
    "/tmp/extracted-jdbc/db2jcc4.jar", \
    "/tmp/extracted-jdbc/sqlj.zip", \
    "/tmp/extracted-jdbc/sqlj4.zip", \
    "/opt/IBM-template/db2/jdbc/" \
    ]

# Create files and links.

WORKDIR /opt/IBM-template/db2/clidriver/lib
RUN ln -s libdb2.so.1  libdb2.so \
 && ln -s libdb2o.so.1 libdb2o.so

# Runtime execution.

ENV SENZING_DOCKER_LAUNCHED=true

WORKDIR /app
ENTRYPOINT ["/app/db2-driver-installer.py"]
CMD ["install"]
