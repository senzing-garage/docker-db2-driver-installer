# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2022-09-29

### Changed in 1.0.4

- In `Dockerfile`, updated FROM instruction to `debian:11.5-slim@sha256:5cf1d98cd0805951484f33b34c1ab25aac7007bb41c8b9901d97e4be3cf3ab04`

## [1.0.3] - 2021-11-04

### Changed in 1.0.3

- Updated Debian version to 10.10

## [1.0.2] - 2020-08-11

### Changed in 1.0.2

- Fixed symbolic link issue with `libdb2o.so` and `libdb2.so`

## [1.0.1] - 2020-01-30

### Changed in 1.0.1

- Upgrade Dockerfile to `FROM debian:10.2`

## [1.0.0] - 2019-08-12

### Added to 1.0.0

- Dockerfile specifying Db2 client code that can be redistributed.
