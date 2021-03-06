#!/bin/bash

set -e

install_devtoolset() {
  echo "Installing dev tools" &&
          yum -y makecache &&
          yum -y grouplist &&
          yum -y groupinstall "Development Tools" &&
          echo "Install dev tools DONE"
}

install_openjdk() {
	echo "Installing openjdk" &&
	yum install -y java-1.8.0-openjdk-devel &&
	echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> $PREREQS_ENV &&
	echo "export JRE_HOME=/usr/lib/jvm/jre" >> $PREREQS_ENV
}

install_mpi() {
	yum install -y mpich-devel &&
	echo "export PATH=/usr/lib64/mpich/bin:\$PATH" >> $PREREQS_ENV &&
	echo "export LD_LIBRARY_PATH=/usr/lib64:/usr/lib:\$LD_LIBRARY_PATH" >> $PREREQS_ENV
}

install_prerequisites_centos() {
	yum update -y -q &&
	yum install -y sudo &&
	yum install -y -q which wget git make cmake cmake3 &&
  install_devtoolset &&
	install_mpi &&
	install_openjdk &&
	yum install -y autoconf automake libtool curl unzip &&
	yum update -y autoconf &&
	yum install -y epel-release &&
	yum install -y zlib-devel &&
	yum install -y openssl-devel &&
	yum install -y libuuid libuuid-devel
}
