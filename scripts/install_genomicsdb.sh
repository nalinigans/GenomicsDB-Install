#!/bin/bash

GENOMICSDB_USER=${1:-genomicsdb}
GENOMICSDB_BRANCH=${2:-develop}
GENOMICSDB_INSTALL_DIR=${3:-/usr/local}
BUILD_DISTRIBUTABLE_LIBRARY=$4
ENABLE_BINDINGS=$5

GENOMICSDB_USER_DIR=`eval echo ~$GENOMICSDB_USER`
GENOMICSDB_DIR=$GENOMICSDB_USER_DIR/GenomicsDB
echo GENOMICSDB_DIR=$GENOMICSDB_DIR

if [[ $BUILD_DISTRIBUTABLE_LIBRARY == true ]]; then
		cmake3 && CMAKE=cmake3
		cmake3 || CMAKE=cmake
else
	CMAKE=cmake
fi

build_genomicsdb() {
	. /etc/profile &&
	git clone https://github.com/GenomicsDB/GenomicsDB -b ${GENOMICSDB_BRANCH} $GENOMICSDB_DIR &&
	pushd $GENOMICSDB_DIR &&
	git submodule update --recursive --init &&
	echo "Building GenomicsDB" &&
	mkdir build &&
	pushd build &&
	$CMAKE .. -DCMAKE_INSTALL_PREFIX=$GENOMICSDB_INSTALL_DIR && make -j 4 && make install &&
	popd &&
	echo "Building GenomicsDB DONE"
	if [[ $ENABLE_BINDINGS == *java* || $BUILD_DISTRIBUTABLE_LIBRARY == true ]]; then
			echo "Building distributable GenomicsDB jars" &&
			mkdir build.distr &&
			pushd build.distr &&
			$CMAKE .. -DCMAKE_INSTALL_PREFIX=$GENOMICSDB_INSTALL_DIR -DBUILD_DISTRIBUTABLE_LIBRARY=1 -DBUILD_JAVA=1 &&
			make -j 4 && make install &&
			popd &&
			echo "Building distributable GenomicsDB jars DONE"
	fi
	popd
}

setup_genomicsdb_env() {
	GENOMICSDB_ENV=/etc/profile.d/genomicsdb_env.sh
	echo "export GENOMICSDB_HOME=$GENOMICSDB_INSTALL_DIR" > $GENOMICSDB_ENV
	if [[ $GENOMICSDB_INSTALL_DIR != "/" ]] &&  [[ $GENOMICSDB_INSTALL_DIR != "/usr" ]]; then
		echo "export PATH=\$GENOMICSDB_HOME/bin:\$PATH" >> $GENOMICSDB_ENV
		echo "export LD_LIBRARY_PATH=\$GENOMICSDB_HOME/lib:\$LD_IBRARY_PATH" >> $GENOMICSDB_ENV
		echo "export C_INCLUDE_PATH=\$GENOMICSDB_HOME/include" >> $GENOMICSDB_ENV
	fi
	if [[ $ENABLE_BINDINGS == *java* ]]; then
			echo "export CLASSPATH=\$GENOMICSDB_HOME/bin:\$CLASSPATH" >> $GENOMICSDB_ENV
	fi
	. /etc/profile
}

install_genomicsdb_python_bindings() {
	if [[ $ENABLE_BINDINGS == *python* ]]; then
		pushd $GENOMICSDB_USER_DIR
		git clone https://github.com/nalinigans/GenomicsDB-Python.git -b develop
		cd GenomicsDB-Python
		virtualenv -p python3 env
		source env/bin/activate > /dev/null
		python setup.py build_ext --inplace --with-genomicsdb=$GENOMICSDB_HOME
		deactivate
		echo "export PYTHONPATH=\$PYTHONPATH:"`pwd` >> $GENOMICSDB_ENV
		popd
	fi
}

install_genomicsdb_r_bindings() {
	if  [[ $ENABLE_BINDINGS == *r* ]]; then
		echo "NOT YET IMPLEMENTED"
	fi
}

build_genomicsdb &&
setup_genomicsdb_env &&
install_genomicsdb_python_bindings &&
install_genomicsdb_r_bindings &&
chown -R $GENOMICSDB_USER:$GENOMICSDB_USER $GENOMICSDB_USER_DIR
