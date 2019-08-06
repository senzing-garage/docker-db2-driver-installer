ARG BASE_IMAGE=debian:9

# -----------------------------------------------------------------------------
# Stage: db2_builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} as db2_builder

ENV REFRESHED_AT=2019-03-22

LABEL Name="senzing/senzing-base-db2-builder" \
      Version="1.0.0"

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

ARG BASE_IMAGE=debian:9
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-07-19

LABEL Name="senzing/senzing-package" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      build-essential \
      checkinstall \
      curl \
      gnupg \
      jq \
      libbz2-dev \
      libc6-dev \
      libffi-dev \
      libgdbm-dev \
      libncursesw5-dev \
      libreadline-gplv2-dev \
      libssl-dev \
      libsqlite3-dev \
      lsb-core \
      lsb-release \
      postgresql-client \
      python-dev \
      python-pip \
      sqlite \
      tk-dev \
      wget \
      vim \
      zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# Install Python 3.7

WORKDIR /usr/src
RUN wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz \
 && tar xzf Python-3.7.3.tgz \
 && cd Python-3.7.3 \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm /usr/src/Python-3.7.3.tgz \
 && rm -rf /usr/src/Python-3.7.3

# Make soft links for Python 3.7. See https://www.python.org/dev/peps/pep-0394

RUN ln -sf /usr/local/bin/easy_install-3.7  /usr/bin/easy_install3 \
 && ln -sf /usr/local/bin/idle3.7           /usr/bin/idle3 \
 && ln -sf /usr/local/bin/pip3.7            /usr/bin/pip3 \
 && ln -sf /usr/local/bin/pydoc3.7          /usr/bin/pydoc3 \
 && ln -sf /usr/local/bin/python3.7         /usr/bin/python3 \
 && ln -sf /usr/local/bin/python3.7m-config /usr/bin/python3-config  \
 && ln -sf /usr/local/bin/pyvenv-3.7        /usr/bin/pyvenv3 \
 && mv /usr/bin/lsb_release /usr/bin/lsb_release.00

# Copy files from repository.

COPY ./rootfs /
COPY ./senzing-package.py /app/
COPY ./downloads/Senzing_API.tgz /app/downloads/

# Copy files from "db2_builder" stage.

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/adm/db2trc", \
    "/opt/IBM/db2/clidriver/adm/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/bin/db2dsdcfgfill", \
    "/opt/IBM/db2/clidriver/bin/db2ldcfg", \
    "/opt/IBM/db2/clidriver/bin/db2lddrg", \
    "/opt/IBM/db2/clidriver/bin/db2level", \
    "/opt/IBM/db2/clidriver/bin/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/cfg/db2cli.ini.sample", \
    "/opt/IBM/db2/clidriver/cfg/db2dsdriver.cfg.sample", \
    "/opt/IBM/db2/clidriver/cfg/db2dsdriver.xsd", \
    "/opt/IBM/db2/clidriver/cfg/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/conv/alt/08501252.cnv", \
    "/opt/IBM/db2/clidriver/conv/alt/12520850.cnv", \
    "/opt/IBM/db2/clidriver/conv/alt/IBM00850.ucs", \
    "/opt/IBM/db2/clidriver/conv/alt/IBM01252.ucs", \
    "/opt/IBM/db2/clidriver/conv/alt/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/include/sqlcli1.h", \
    "/opt/IBM/db2/clidriver/include/sqlsystm.h", \
    "/opt/IBM/db2/clidriver/include/sqlca.h", \
    "/opt/IBM/db2/clidriver/include/sqlcli.h", \
    "/opt/IBM/db2/clidriver/include/sql.h", \
    "/opt/IBM/db2/clidriver/include/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/lib/libdb2.so.1", \
    "/opt/IBM/db2/clidriver/lib/libdb2o.so.1", \
    "/opt/IBM/db2/clidriver/lib/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8cms_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8iccs_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8km_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8ssl_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/libgsk8sys_64.so", \
    "/opt/IBM/db2/clidriver/lib/icc/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/ICCSIG.txt", \
    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/libicclib084.so", \
    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/" \
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
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/" \
    ]

COPY --from=db2_builder [ \
    "/tmp/extracted-jdbc/db2jcc.jar", \
    "/tmp/extracted-jdbc/db2jcc4.jar", \
    "/tmp/extracted-jdbc/sqlj.zip", \
    "/tmp/extracted-jdbc/sqlj4.zip", \
    "/opt/IBM/db2/jdbc/" \
    ]

# Create files and links.

RUN ln -s /opt/IBM/db2/clidriver/lib/libdb2.so.1  /opt/IBM/db2/clidriver/lib/libdb2.so \
 && ln -s /opt/IBM/db2/clidriver/lib/libdb2o.so.1 /opt/IBM/db2/clidriver/lib/libdb2o.so

# Runtime execution.

ENV SENZING_DOCKER_LAUNCHED=true

WORKDIR /app
ENTRYPOINT ["/app/senzing-package.py"]
