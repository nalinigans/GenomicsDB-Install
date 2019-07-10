# GenomicsDB-Install
Experimental scripts to build and install [GenomicsDB](https://github.com/GenomicsDB/GenomicsDB). Support initially only for ubuntu.

## With Docker
To build and install GenomicsDB using Docker, specify the following optional build arguments

  | Build Argument | Default |
  | --- | --- |
  | os=ubuntu:trusty|centos:7|<any linux base> | ubuntu:trusty |
  | user=<user_name> | genomicdb |
  | branch=master|develop|<any_branch> | master |
  | install_dir=<my_install_dir> | /usr/local |
  | enable_bindings=java,r,python | none |
  
```
git clone https://github.com/GenomicsDB/GenomicsDB-Install.git
docker build --build-arg os=ubuntu branch=develop install_dir=/home/$USER -t genomicsdb:develop
```

To run:
```
 docker run -it genomicsdb:develop
```

## Directly from bash
The two scripts [install_prereqs.sh](scripts/prereqs/install_prereqs.sh) and [install_genomicsdb.sh](scripts/install_genomicsdb.sh) will work on any Linux OS from a bash shell without Docker.

```bash
git clone https://github.com/GenomicsDB/GenomicsDB-Install.git
sudo scripts/prereqs/install_prereqs.sh # This will install all the prerequisites necessary to build genomicsdb
scripts/install_genomicsdb.sh $USER <branch> <install_dir> <enable_bindings> # Arguments are optional
cd ~$USER/GenomicsDB # To browse through the GenomicsDB source
cd ~$USER/GenomicsDB/build # To look at the build components and run tests
```
