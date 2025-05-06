# docker-db2-driver-installer

If you are beginning your journey with [Senzing],
please start with [Senzing Quick Start guides].

You are in the [Senzing Garage] where projects are "tinkered" on.
Although this GitHub repository may help you understand an approach to using Senzing,
it's not considered to be "production ready" and is not considered to be part of the Senzing product.
Heck, it may not even be appropriate for your application of Senzing!

## Overview

The `senzing/db2-driver-installer` docker image installs redistributable Db2 client code into
a mounted volume.

### Related artifacts

1. [DockerHub]
1. [Helm Chart]

### Contents

1. [Expectations]
   1. [Space]
   1. [Time]
   1. [Background knowledge]
1. [Demonstrate using Docker]
   1. [Configuration]
   1. [Volumes]
   1. [Docker network]
   1. [Run docker container]
1. [Develop]
   1. [Prerequisite software]
   1. [Clone repository]
   1. [Downloads]
   1. [Build docker image for development]
1. [Examples]
1. [Errors]
1. [References]

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps you'll need to make some choices.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

### Space

This repository and demonstration require 1 GB free disk space.

### Time

Budget 20 minutes to get the demonstration up-and-running, depending on CPU and network speeds.

### Background knowledge

This repository assumes a working knowledge of:

1. [Docker]

## Demonstrate using Docker

### Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_OPT_IBM_DIR]**

### Volumes

1. :pencil2: Specify the directory containing the Senzing installation.
   Example:

   ```console
   export SENZING_VOLUME=/opt/my-senzing
   ```

   1. Here's a simple test to see if `SENZING_VOLUME` is correct.
      The following commands should return file contents.
      Example:

      ```console
      cat ${SENZING_VOLUME}/g2/g2BuildVersion.json
      ```

   1. :warning:
      **macOS** - [File sharing MacOS]
      must be enabled for `SENZING_VOLUME`.
   1. :warning:
      **Windows** - [File sharing Windows]
      must be enabled for `SENZING_VOLUME`.

1. Specify directory for IBM DB2 drivers.
   Example:

   ```console
   export SENZING_OPT_IBM_DIR=${SENZING_VOLUME}/opt-ibm
   ```

### Docker network

:thinking: **Optional:** Use if docker container is part of a docker network.

1. List docker networks.
   Example:

   ```console
   sudo docker network ls
   ```

1. :pencil2: Specify docker network.
   Choose value from NAME column of `docker network ls`.
   Example:

   ```console
   export SENZING_NETWORK=*name_of_the_network*
   ```

1. Construct parameter for `docker run`.
   Example:

   ```console
   export SENZING_NETWORK_PARAMETER="--net ${SENZING_NETWORK}"
   ```

### Run docker container

1. Run docker container.
   Example:

   ```console
   sudo docker run \
     --rm \
     --volume ${SENZING_OPT_IBM_DIR}:/opt/IBM \
     ${SENZING_NETWORK_PARAMETER} \
     senzing/db2-driver-installer
   ```

## Develop

### Prerequisite software

The following software programs need to be installed:

1. [git]
1. [make]
1. [Docker]

### Clone repository

For more information on environment variables,
see [Environment Variables].

1. Set these environment variable values:

   ```console
   export GIT_ACCOUNT=senzing
   export GIT_REPOSITORY=docker-db2-driver-installer
   export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
   export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
   ```

1. Follow steps in [clone-repository] to install the Git repository.

### Downloads

#### Download ibm_data_server_driver_for_odbc_cli_linuxx64_v11.1.tar.gz

1. Visit [Download initial Version 11.1 clients and drivers]
   1. Click on "[IBM Data Server Driver for ODBC and CLI (CLI Driver)]" link.
   1. Select :radio_button: "IBM Data Server Driver for ODBC and CLI (Linux AMD64 and Intel EM64T)"
   1. Click "Continue" button.
   1. Choose download method and click "Download now" button.
   1. Download `ibm_data_server_driver_for_odbc_cli_linuxx64_v11.1.tar.gz` to ${GIT_REPOSITORY_DIR}/[downloads] directory.

#### Download v11.1.4fp4a_jdbc_sqlj.tar.gz

1. Visit [DB2 JDBC Driver Versions and Downloads]
   1. In DB2 Version 11.1 > JDBC 3.0 Driver version, click on "3.72.52" link for "v11.1 M4 FP4 iFix1"
   1. Click on "DSClients--jdbc_sqlj-11.1.4.4-FP004a" link.
   1. Click on "v11.1.4fp4a_jdbc_sqlj.tar.gz" link to download.
   1. Download `v11.1.4fp4a_jdbc_sqlj.tar.gz` to ${GIT_REPOSITORY_DIR}/[downloads] directory.

### Build docker image for development

1. **Option #1:** Using `docker` command and local repository.

   ```console
   cd ${GIT_REPOSITORY_DIR}
   sudo docker build --tag senzing/db2-driver-installer .
   ```

1. **Option #2:** Using `make` command.

   ```console
   cd ${GIT_REPOSITORY_DIR}
   sudo make docker-build
   ```

   Note: `sudo make docker-build-development-cache` can be used to create cached docker layers.

## Examples

## Errors

1. See [docs/errors.md].

## References

1. [How to support Db2]

[Background knowledge]: #background-knowledge
[Build docker image for development]: #build-docker-image-for-development
[Clone repository]: #clone-repository
[clone-repository]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/clone-repository.md
[Configuration]: #configuration
[DB2 JDBC Driver Versions and Downloads]: http://www-01.ibm.com/support/docview.wss?uid=swg21363866
[Demonstrate using Docker]: #demonstrate-using-docker
[Develop]: #develop
[Docker network]: #docker-network
[Docker]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md
[DockerHub]: https://hub.docker.com/r/senzing/db2-driver-installer
[docs/errors.md]: docs/errors.md
[Download initial Version 11.1 clients and drivers]: http://www-01.ibm.com/support/docview.wss?uid=swg21385217
[downloads]: ./downloads
[Downloads]: #downloads
[Environment Variables]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md
[Errors]: #errors
[Examples]: #examples
[Expectations]: #expectations
[File sharing MacOS]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/share-directories-with-docker.md#macos
[File sharing Windows]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/share-directories-with-docker.md#windows
[git]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/git.md
[Helm Chart]: https://github.com/senzing-garage/charts/tree/main/charts/ibm-db2-driver-installer
[How to support Db2]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/support-db2.md
[IBM Data Server Driver for ODBC and CLI (CLI Driver)]: http://www.ibm.com/services/forms/preLogin.do?source=swg-idsoc97
[make]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/make.md
[Prerequisite software]: #prerequisite-software
[References]: #references
[Run docker container]: #run-docker-container
[Senzing Garage]: https://github.com/senzing-garage
[Senzing Quick Start guides]: https://docs.senzing.com/quickstart/
[SENZING_OPT_IBM_DIR]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#senzing_opt_ibm_dir
[Senzing]: https://senzing.com/
[Space]: #space
[Time]: #time
[Volumes]: #volumes
