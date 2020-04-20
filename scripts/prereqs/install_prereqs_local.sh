#!/bin/bash

OPENSSL_VERSION=1.0.2o
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
    test -d $M2_HOME  &&
    echo "# Maven env" >> $HOME/.bashrc &&
    echo "export M2_HOME=$M2_HOME" >> $HOME/.bashrc &&
    echo "export PATH=\${M2_HOME}/bin:\${PATH}" >>  $HOME/.bashrc &&
    echo >> $HOME/.bashrc
}

install_protobuf() {
    echo "Installing Protobuf"
    pushd /tmp
    git clone -b 3.0.x --single-branch https://github.com/google/protobuf.git &&
    pushd protobuf &&
    ./autogen.sh &&
    ./configure --prefix=$HOME --with-pic &&
    make -j4 && make install &&
    echo "Installing Protobuf DONE"
    popd
    rm -fr /tmp/protobuf*
    popd
}

install_openssl() {
    echo "Installing OpenSSL"
    pushd /tmp
    wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz &&
    tar -xvzf openssl-$OPENSSL_VERSION.tar.gz &&
    cd openssl-$OPENSSL_VERSION &&
    CFLAGS=-fPIC ./config --prefix=$HOME/openssl -fPIC -shared
    make && make install && echo "Installing OpenSSL DONE"
    popd
    echo "# OpenSSL env" >> $HOME/.bashrc &&
    echo "export OPENSSL_ROOT_DIR=$HOME/openssl" >> $HOME/.bashrc
    rm -fr /tmp/openssl*
}

install_curl() {
    echo "Installing CURL"
    pushd /tmp
    git clone https://github.com/curl/curl.git &&
    cd curl &&
    autoreconf -i &&
    ./configure --enable-lib-only --prefix=$HOME &&
    make && make install && echo "Installing CURL DONE"
    popd
    rm -fr /tmp/curl
}

install_uuid() {
    echo "Installing libuuid"
    pushd /tmp
    wget https://sourceforge.net/projects/libuuid/files/libuuid-1.0.3.tar.gz &&
    tar -xvzf libuuid-1.0.3.tar.gz &&
    cd libuuid-1.0.3 &&
    sed -i s/2.69/2.63/ configure.ac &&
    aclocal &&
    automake --add-missing &&
    ./configure --prefix $HOME --with-pic CFLAGS="-I/usr/include/x86_64-linux-gnu" --disable-shared --enable-static &&
    autoreconf -i -f &&
    make && make install && echo "Installing libuuid DONE"
    popd
    rm -fr /tmp/libuuid*
}

install_mvn &&
install_protobuf &&
echo "Installing static libraries" &&
install_openssl &&
install_curl &&
install_uuid
