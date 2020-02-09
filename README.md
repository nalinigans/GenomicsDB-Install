# GenomicsDB-Install
Experimental scripts to build and install [GenomicsDB](https://github.com/GenomicsDB/GenomicsDB). Support initially only for ubuntu and centos 7. Note that the bindings are unofficial and strictly mine from https://github.com/nalinigans/GenomicsDB-R and https://github.com/nalinigans/GenomicsDB-Python.

## With Docker
To build and install GenomicsDB using Docker, specify the following *optional* build arguments

  | Build Argument | Default |
  | --- | --- |
  | os=ubuntu:trusty\|centos:7\|\<linux_base:ver\> | centos:7 |
  | user=<user_name> | genomicdb |
  | branch=master\|develop\|<any_branch> | master |
  | install_dir=<my_install_dir> | /usr/local |
  | distributable_library=true\|false | false |  
  | enable_bindings=java,r,python | none |
  
Examples:
```
git clone https://github.com/nalinigans/GenomicsDB-Install.git
cd GenomicsDB-Install
docker build --build-arg os=ubuntu --build-arg branch=develop --build-arg install_dir=/home/$USER -t genomicsdb:build . 
```

To run and enter the bash shell:
```
# Use the -t argument value used with docker build ...
docker run -it genomicsdb:build
```

To build and copy all built artifacts from the docker image:
```
export docker_os=centos
export docker_repo=genomicsdb
export docker_tag=`date "+%Y-%m-%d-%H:%M:%S"`
docker build --build-arg os=$docker_os --build-arg install_dir=/tmp/artifacts -t $docker_repo:$docker_tag .
docker create -it --name genomicsdb $docker_repo:$docker_tag bash
docker cp genomicsdb:/tmp/artifacts $docker_os
docker rm -fv genomicsdb
```

To delete docker images:
```
docker build --build-arg os=$docker_os install_dir=/tmp/artifacts -t $docker_repo:$docker_tag .
docker image rm -f $docker_repo:$docker_tag
docker system prune #optional
```

## Directly from bash
The two scripts [install_prereqs.sh](scripts/prereqs/install_prereqs.sh) and [install_genomicsdb.sh](scripts/install_genomicsdb.sh) will work on any Linux OS from a bash shell without Docker.

```bash
git clone https://github.com/nalinigans/GenomicsDB-Install.git
sudo scripts/prereqs/install_prereqs.sh # This will install all the prerequisites necessary to build genomicsdb
scripts/install_genomicsdb.sh $USER <branch> <install_dir> <enable_bindings> # Arguments are optional
cd ~$USER/GenomicsDB # To browse through the GenomicsDB source
cd ~$USER/GenomicsDB/build # To look at the build components and run tests
```
