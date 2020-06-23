!/bin/bash
# Install GenomicsDB Dependencies
brew install cmake

# protobufbrew install protobuf@3.1export PROTOBUF_LIBRARY=/usr/local/Cellar/protobuf@3.1/3.1.0
brew install mpichi
brew install openssl
brew install openssl-dev
brew install ossp-uuid
brew install automake

# Maven
wget http://apache.mirrors.lucidnetworks.net/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar xvfz apache-maven-3.5.4-bin.tar
export M2_HOME=~/apache-maven-3.5.4
export PATH=$M2_HOME/bin:$PATH

# Build GenomicsDB
git clone https://github.com/GenomicsDB/GenomicsDB.git
cd GenomicsDB
mkdir build 
cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~ -DBUILD_JAVA=1 -DOPENSSL_ROOT_DIR=/usr/local/Cellar/openssl/1.0.2o_1 -DOPENSSL_LIBRARIES=/usr/local/Cellar/openssl/1.0.2o_1/lib -DPROTOBUF_LIBRARIES=/usr/local/Cellar/protobuf\@3.1/3.1.0/lib/libprotobuf.dylib -DProtobuf_INCLUDE_DIR=/usr/local/Cellar/protobuf\@3.1/3.1.0/include ..
make -j4 && make install
