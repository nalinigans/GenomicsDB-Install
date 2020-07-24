#!/bin/bash

set -e 

if [[ `uname` != "Darwin" ]]; then
  echo "Run install_genomicsdb.sh instead"
  exit 1
fi

# Install GenomicsDB Dependencies
brew list cmake &>/dev/null || brew install cmake
brew list mpich &>/dev/null || brew install mpich
brew list ossp-uuid &>/dev/null || brew install ossp-uuid
brew list libcsdb &>/dev/null || brew install libcsv
brew list automake &> /dev/null || brew install automake

MAVEN_VERSION=3.6.3
install_mvn() {
    echo "Installing Maven"
    MVN=`which mvn`
    if [ -z $MVN ]; then
        wget -nv https://www-us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp &&
        tar xf /tmp/apache-maven-*.tar.gz -C $HOME &&
        rm /tmp/apache-maven-*.tar.gz
        ln -s $HOME/apache-maven-$MAVEN_VERSION $HOME/maven &&
        MVN=$HOME/bin/mvn &&
        test -f $MVN &&
        echo "Installing Maven DONE"
    fi
    MVN_BIN_DIR=`dirname ${MVN}`
    M2_HOME=`dirname ${MVN_BIN_DIR}`
    export PATH=$M2_HOME/bin:$PATH
}

PROTOBUF_VERSION=3.0.0-beta-1
PROTOBUF_PREFIX=$HOME/protobuf.$PROTOBUF_VERSION
install_protobuf() {
	if [[ -d $PROTOBUF_PREFIX ]]; then
		return 0
	fi
		
    echo "Installing Protobuf"
    pushd /tmp

	wget -nv https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.zip &&
    unzip protobuf-cpp-$PROTOBUF_VERSION.zip &&
    cd protobuf-$PROTOBUF_VERSION &&
    ./autogen.sh &&
    ./configure --prefix=$PROTOBUF_PREFIX --with-pic &&
    make -j4 && make install &&
    echo "Installing Protobuf DONE"
	
    popd
    rm -fr /tmp/protobuf*
}

OPENSSL_VERSION=1.0.2s
OPENSSL_PREFIX=$HOME/openssl.$OPENSSL_VERSION
install_openssl() {
	if [[ -d $OPENSSL_PREFIX ]]; then
		return 0
	fi

	echo "Installing OpenSSL"
	pushd /tmp
	
	wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz &&
		tar -xvzf openssl-$OPENSSL_VERSION.tar.gz &&
		cd openssl-$OPENSSL_VERSION &&
		./configure darwin64-x86_64-cc shared -fPIC --prefix=$OPENSSL_PREFIX
	make depend && make && make install && echo "Installing OpenSSL DONE"
	
	popd
	rm -fr /tmp/openssl*
}

set_cmake_env() {
	export OPENSSL_ROOT_DIR=$OPENSSL_PREFIX
    export CMAKE_PREFIX_PATH=$PROTOBUF_PREFIX:$OPENSSL_ROOT_DIR
}

# Build GenomicsDB
install_mvn
install_protobuf
install_openssl

git clone https://github.com/GenomicsDB/GenomicsDB.git
cd GenomicsDB
mkdir build 
cd build

set_cmake_env
cmake -DCMAKE_INSTALL_PREFIX=$HOME/genomicsdb -DBUILD_JAVA=1 -DCMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH .. &&
	make -j4 && make install && && echo && echo "Installed GenomicsDB successfully in $HOME/genomicsdb"

echo
echo "###############################################################################################"
echo "#To build GenomicsDB again with the installed prerequisites from this script. Do the following -"
echo "export OPENSSL_ROOT_DIR=$OPENSSL_PREFIX"
echo "export CMAKE_PREFIX_PATH=$PROTOBUF_PREFIX:$OPENSSL_ROOT_DIR"
echo "git clone https://github.com/GenomicsDB/GenomicsDB.git"
echo "cd GenomicsDB"
echo "mkdir build"
echo "cd build"
echo "cmake -DCMAKE_INSTALL_PREFIX=\$HOME/genomicsdb -DBUILD_JAVA=1 -DCMAKE_PREFIX_PATH=\$CMAKE_PREFIX_PATH .."
echo "make -j4 && make install"
echo "make test #optional - Python 2.7.3 should be functional to run the tests successfully"
echo "###############################################################################################"
echo
echo
