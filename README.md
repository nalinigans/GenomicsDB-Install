# GenomicsDB-Install
Experimental scripts to build and install GenomicsDB. Support initially only for ubuntu.

## With Docker
To build and install GenomicsDB using Docker, specify the following optional build arguments

  | Build Argument | Default |
  | --- | --- |
  | os=ubuntu:trusty|centos:7|<any linux base> | ubuntu:trusty |
  | branch=master|develop|<any_branch> | master |
  | install_dir=<my_install_dir> | /usr/local |
  | enable_bindings=java,r,python | none |
  
```
git clone https://github.com/GenomicsDB/GenomicsDB-Install.git
docker build --build-arg os=ubuntu branch=develop install_dir=/home/$USER -t genomicsdb:develop
```

To run and enter the bash shell:
```
 docker run -it genomicsdb:develop
```

## Directly from bash
The two scripts [install_prereqs.sh](scripts/prereqs/install_prereq.sh) and [install_genomicsdb.sh](scripts/install_genomicsdb.sh) will work on any Linux OS from a bash command line without Docker.
