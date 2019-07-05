#!/bin/bash

GENOMICSDB_DIR=${GENOMICSDB_DIR:-$HOME/GenomicsDB}
GENOMICSDB_BUILD_DIR=$GENOMICSDB_DIR/build
GENOMICSDB_INSTALL_DIR=${GENOMICSDB_INSTALL_DIR:-$HOME}
PATH=$GENOMICSDB_INSTALL_DIR/bin:$PATH
GENOMICSDB_ENV=/etc/profile.d/genomicsdb_env.sh
touch $GENOMICSDB_ENV

install_openjdk8() {
	apt-get -y install openjdk-8-jdk icedtea-plugin &&
	apt-get update -q &&
	pushd $HOME &&
	git clone https://github.com/michaelklishin/jdk_switcher.git &&
	source jdk_switcher/jdk_switcher.sh && jdk_switcher use openjdk8 &&
	echo "export \$JAVA_HOME=$JAVA_HOME" > $GENOMICSDB_ENV &&
	popd
}

install_mvn() {
	MVN=`which mvn`
	if [ -z MVN ]; then
		wget https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -P /tmp &&
		tar xf /tmp/apache-maven-*.tar.gz -C /opt &&
		rm /tmp/apache-maven-*.tar.gz
		ln -s /opt/apache-maven-3.6.0 /opt/maven &&
		MVN=/opt/maven/bin/mvn &&
		test -f $MVN
	fi
	MVN_BIN_DIR=`dirname ${MVN}`
	M2_HOME=`dirname ${MVN_BIN_DIR}`
	test -d $M2_HOME  &&
	echo "export M2_HOME=$M2_HOME" >  $GENOMICSDB_ENV &&
	echo "export PATH=\${M2_HOME}/bin:\${PATH}" >  $GENOMICSDB_ENV
}

install_protobuf() {
	pushd /tmp &&
	wget -nv https://github.com/GenomicsDB/GenomicsDB/releases/download/v1.0.0/protobuf-3.0.2-trusty.tar.gz -O protobuf-3.0.2-trusty.tar.gz &&
	tar xzf protobuf-3.0.2-trusty.tar.gz && sudo rsync -a protobuf-3.0.2-trusty/ /usr/  &&
	rm -fr /tmp/protobuf* &&
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
					zip \
					unzip &&
	apt-get update -q &&
	add-apt-repository ppa:ubuntu-toolchain-r/test -y &&
	add-apt-repository -y ppa:openjdk-r/ppa &&
	apt-get update -q &&
	apt-get install gcc-4.9 -y &&
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 &&
	apt-get install g++-4.9 -y &&
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 60 &&
	install_openjdk8 &&
	install_mvn &&
	install_protobuf
}

install_genomicsdb() {
	cd /home/genomicsdb &&
	git clone https://github.com/GenomicsDB/GenomicsDB -b develop $GENOMICSDB_DIR &&
	pushd $GENOMICSDB_DIR && git submodule update --recursive --init && popd &&
	mkdir $GENOMICSDB_BUILD_DIR &&
	pushd $GENOMICSDB_BUILD_DIR &&
	cmake $GENOMICSDB_DIR -DCMAKE_INSTALL_PREFIX=$GENOMICSDB_INSTALL_DIR &&
	make -j 4 &&
	make install &&
	test -f $GENOMICSDB_INSTALL_DIR/include/genomicsdb.h &&
	test -f $GENOMICSDB_INSTALL_DIR/lib/libtiledbgenomicsdb.so &&
	popd
}

install_prerequisites_ubuntu &&

useradd genomicsdb &&
mkdir /home/genomicsdb &&
cd /home/genomicsdb &&

install_genomicsdb &&

chown -R genomicsdb: /home/genomicsdb
