FROM centos:7
MAINTAINER Caltech IMSS ADS <imss-ads-staff@caltech.edu>

USER root

WORKDIR /etc
RUN rm -rf localtime && ln -s /usr/share/zoneinfo/America/Los_Angeles localtime
ENV LC_ALL en_US.UTF-8
ENV PYTHONUNBUFFERED 1
# Check https://pypy.org/download.html for new stable releases of pypy3-3.6
ENV PYPY3_VERSION 3.6-v7.3.0

#install packages
RUN yum -y install epel-release && \
    yum -y makecache fast && \
    yum update -y && \
    yum install -y \
        gcc \
        git \
        make \
        libffi-devel \
        pkgconfig \
        zlib-devel \
        bzip2-devel \
        sqlite-devel \
        ncurses-devel \
        openssl-devel \
        expat-devel \
        tk-devel \
        gdbm-devel \
        python-cffi \
        xz-devel \
        # interestingly we bootstrap our compiled pypy below with this older pypy from yum
        # https://pypy.readthedocs.io/en/latest/build.html
        # the pypy rpm comes from EPEL
        pypy \
        # Useful unix utilities that don't come with the base CentOS 7 image.
        wget \
        bzip2 \
        which \
        vim \
        less \
        file \
    && yum -y clean all && \
    # Set up the UTF-8 locale so that shelling into the container won't spam you with locale errors.
    localedef -i en_US -f UTF-8 en_US.UTF-8

#Build and install our pypy-3.6
#See: https://pypy.readthedocs.io/en/latest/build.html
WORKDIR /usr/src
RUN wget --no-check-certificate -c https://bitbucket.org/pypy/pypy/downloads/pypy${PYPY3_VERSION}-src.tar.bz2 && \
    tar jxf pypy${PYPY3_VERSION}-src.tar.bz2 && \
    cd pypy${PYPY3_VERSION}-src/pypy/goal && \
    pypy ../../rpython/bin/rpython --opt=jit 
RUN cd pypy${PYPY3_VERSION}-src/pypy/goal && \
    PYTHONPATH=../.. ./pypy3-c ../tool/build_cffi_imports.py && \
    cd ../tool/release && \
    ./package.py --archive-name=pypy${PYPY3_VERSION}-centos7
RUN mv /tmp/usession-release-pypy${PYPY3_VERSION}*-current/build/pypy${PYPY3_VERSION}-centos7 /opt/pypy && \
    /opt/pypy/bin/pypy3 -m ensurepip

ENV PATH /opt/pypy/bin:$PATH
    
CMD ["/bin/bash"]
