#!/bin/bash

install_openjdk8() {
	apt-get -y install openjdk-8-jdk icedtea-plugin &&
	apt-get update -q &&
	pushd $HOME &&
	git clone https://github.com/michaelklishin/jdk_switcher.git &&
	source jdk_switcher/jdk_switcher.sh && jdk_switcher use openjdk8 &&
	echo "export JAVA_HOME=$JAVA_HOME" >> $PREREQS_ENV &&
	popd
}

install_prerequisites_ubuntu() {
	apt-get update -q &&
	apt-get -y install \
					lcov \
					mpich \
					zlib1g-dev \
					libssl-dev \
					rsync \
					cmake3 \
					uuid-dev \
					libcurl4-openssl-dev \
					software-properties-common \
					wget \
					git \
					autoconf \
					automake \
					libtool \
					zip \
					unzip \
					curl \
					sudo &&
	apt-get update -q &&
	add-apt-repository ppa:ubuntu-toolchain-r/test -y &&
	add-apt-repository -y ppa:openjdk-r/ppa &&
	apt-get update -q &&
	apt-get install gcc-4.9 -y &&
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 &&
	apt-get install g++-4.9 -y &&
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 60 &&
	install_openjdk8 &&
	apt-get clean &&
  apt-get purge -y &&
  rm -rf /var/lib/apt/lists*
}
