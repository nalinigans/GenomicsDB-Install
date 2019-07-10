#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage ./install_genomicsdb.sh <user_name> <genomicsdb_branch> <install_dir> <bindings>"
	echo "      argument <user_name> is mandatory, other arguments are optional"
	exit 1
fi

GENOMICSDB_USER=$1
GENOMICSDB_BRANCH=${2:-master}
GENOMICSDB_INSTALL_DIR=${3:-/usr/local}

if [ $# > 3 ] && [[ $4 == *java* ]]; then
	BUILD_JAVA=1
else
	BUILD_JAVA=0
fi

GENOMICSDB_DIR=`eval echo ~$GENOMICSDB_USER`/GenomicsDB
echo GENOMICSDB_DIR=$GENOMICSDB_DIR

build_genomicsdb() {
	. /etc/profile &&
	git clone https://github.com/GenomicsDB/GenomicsDB -b ${GENOMICSDB_BRANCH} $GENOMICSDB_DIR &&
	pushd $GENOMICSDB_DIR &&
	git submodule update --recursive --init &&
	mkdir build &&
	cd build &&
	cmake .. -DCMAKE_INSTALL_PREFIX=$GENOMICSDB_INSTALL_DIR -DBUILD_JAVA=$BUILD_JAVA &&
	make -j 4 &&
	make install &&
	chown -R $GENOMICSDB_USER $GENOMICSDB_DIR &&
	popd
}

setup_genomicsdb_env() {
	GENOMICSDB_ENV=/etc/profile.d/genomicsdb_env.sh
	echo "export GENOMICSDB_HOME=$GENOMICSDB_INSTALL_DIR" > $GENOMICSDB_ENV
	if [[ $GENOMICSDB_INSTALL_DIR != "/usr" ]] &&  [[ $GENOMICSDB_INSTALL_DIR != "/usr/local" ]]; then
			echo "export PATH=\$GENOMICSDB_HOME/bin:\$PATH" >> $GENOMICSDB_ENV
			echo "export LD_LIBRARY_PATH=\$GENOMICSDB_HOME/lib:\$LD_IBRARY_PATH" >> $GENOMICSDB_ENV
	fi
	if [ $BUILD_JAVA = 1 ]; then
			echo "export CLASSPATH=\$GENOMICSDB_HOME/bin:\$CLASSPATH" >> $GENOMICSDB_ENV
	fi
	. /etc/profile
}

build_genomicsdb &&
setup_genomicsdb_env

