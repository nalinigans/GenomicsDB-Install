#!/bin/bash

PREREQS_ENV=/etc/profile.d/prereqs.sh
touch $PREREQS_ENV

install_mvn() {
	echo "Installing Maven"
	MVN=`which mvn`
	if [ -z $MVN ]; then
		wget -nv https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -P /tmp &&
		tar xf /tmp/apache-maven-*.tar.gz -C /opt &&
		rm /tmp/apache-maven-*.tar.gz
		ln -s /opt/apache-maven-3.6.0 /opt/maven &&
		MVN=/opt/maven/bin/mvn &&
		test -f $MVN
	fi
	MVN_BIN_DIR=`dirname ${MVN}`
	M2_HOME=`dirname ${MVN_BIN_DIR}`
	test -d $M2_HOME  &&
	echo "export M2_HOME=$M2_HOME" >>  $PREREQS_ENV &&
	echo "export PATH=\${M2_HOME}/bin:\${PATH}" >>  $PREREQS_ENV
}

install_protobuf() {
	echo "Installing Protobuf"
	pushd /tmp &&
	git clone -b 3.0.x --single-branch https://github.com/google/protobuf.git &&
	pushd protobuf &&
	./autogen.sh &&
	./configure --prefix=/usr --with-pic &&
	make -j4 && make install &&
	popd &&
	rm -fr /tmp/protobuf* &&
	popd
}

install_os_prerequisites() {
	case `uname` in
		Linux )
			apt-get --version && source install_ubuntu_prereqs.sh && install_prerequisites_ubuntu
			yum version && source install_centos_prereqs.sh && install_prerequisites_centos
			;;
		Darwin )
			echo "Mac OS not yet supported"
			exit 1
	esac
}

install_prerequisites() {
	install_os_prerequisites &&
	source $PREREQS_ENV &&
	install_mvn &&
	install_protobuf
}

install_prerequisites
