FROM opensuse
MAINTAINER Casey Law <caseyjlaw@gmail.com>

ENV USER root
ENV CASAPATH /home/casa-release-4.3.1-el6/
ENV PATH $PATH:/home/casa-release-4.3.1-el6/bin/

WORKDIR /home

# Install OpenSUSE basics and CASA requirements
RUN /usr/bin/zypper refresh
RUN ["/usr/bin/zypper", "--non-interactive", "install", "wget", "tar", "which", "unzip", "xauth", "patchelf", "man", "libgthread-2_0-0", "libpng12-0", "libfreetype6", "libSM6", "libXi6", "libXrender1", "libXrandr2", "libXfixes3", "libXcursor1", "libXinerama1", "fontconfig", "libxslt1", "python-devel", "ipython", "python-numpy-devel", "python-scipy", "python-Cython", "gcc", "python-pip", "fftw3-devel", "fftw3-threads-devel"]

# Install and patch CASA
ADD patchscript.sh /home/patchscript.sh
RUN /usr/bin/wget -nv --no-check-certificate https://svn.cv.nrao.edu/casa/linux_distro/release/el6/casa-release-4.3.1-el6.tar.gz
RUN tar xvf casa-release-4.3.1-el6.tar.gz
RUN /home/patchscript.sh /home/casa-release-4.3.1-el6 /usr/lib/python2.7/site-packages
RUN cp -r /usr/lib64/python2.7/site-packages/numpy/core/include/numpy /usr/include/python/

# Install project software from github
RUN \
    /usr/bin/wget -nv --no-check-certificate https://github.com/caseyjlaw/sdmreader/archive/master.zip && \
    /usr/bin/unzip master.zip && \
    rm master.zip && \
    cd sdmreader-master && \
    /usr/bin/python setup.py install

RUN \
    /usr/bin/wget -nv --no-check-certificate https://github.com/caseyjlaw/sdmpy/archive/master.zip && \
    /usr/bin/unzip master.zip && \
    rm master.zip && \
    cd sdmpy-master && \
    /usr/bin/python setup.py install

RUN \
    /usr/bin/wget -nv --no-check-certificate https://github.com/caseyjlaw/rtpipe/archive/master.zip && \
    /usr/bin/unzip master.zip && \
    rm master.zip && \
    cd rtpipe-master && \
    rm rtlib_cython.c rtlib_cython.so && \
    # build cython code
    python setup.py build_ext --inplace && \
    # place in python path
    cd .. && \
    cp -r rtpipe-master /usr/lib/python2.7/site-packages/rtpipe

RUN pip install pyfftw

# Move in Peter's casa-python libraries
ADD casautil.py kwargv.py tasklib.py /usr/lib/python2.7/site-packages/

