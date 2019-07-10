# GenomicsDB-Install
Experimental scripts to build and install GenomicsDB. Support initially only for ubuntu.

To build and install GenomicsDB, specify the following optional build arguments
  | os=ubuntu:trusty|centos:7|<any linux base> | default is ubuntu:trusty
  | branch=master|develop|<any_branch>         | default is master
  | install_dir=<my_install_dir>               | default is /usr/local
  | enable_bindings=java,r,python              | default is none
  
```
git clone https://github.com/GenomicsDB/GenomicsDB-Install.git
docker build --build-arg os=ubuntu branch=develop install_dir=/home/$USER -t genomicsdb:develop
```

To run:
```
 docker run -it genomicsdb:develop
```
