# Docker file for GenomicsDB for Ubuntu Trusty distro

# Ubuntu Trusty
FROM ubuntu:trusty

ADD . /ubuntu
WORKDIR /ubuntu
RUN scripts/install_genomicsdb.sh
