#!/bin/bash

install_prerequisites_centos() {
	yum update -y -q &&
	yum install -y -q wget &&
	yum install -y java-1.8.0-openjdk-devel &&
	# ADD JAVA_HOME="/usr/lib/jvm/jre-1.8.0-openjdk" && JRE_HOME=/usr/lib/jvm/jre

	yum -y install autoconf automake libtool curl make unzip &&
  yum -y update autoconf &&
  yum -y install mpich-devel &&
  yum -y install epel-release &&
  yum -y install libcsv libcsv-devel &&
  yum -y install zlib-devel &&
  yum -y install cmake cmake3 &&
	yum install -y openssl-devel &&
  yum -y install libuuid libuuid-devel &&
	yum -y install python-pip &&
  pip install jsondiff &&
  yum -y install lcov &&
  yum -y install csv
}
