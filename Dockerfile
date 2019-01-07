FROM dockcross/base:latest
LABEL maintainer="nknotts@gmail.com"

# forked from https://github.com/jcfr/dockcross/blob/master/darwin-x64/Dockerfile

ENV CROSS_TRIPLE x86_64-apple-darwin14
ENV CROSS_ROOT /usr/${CROSS_TRIPLE}
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV LD_LIBRARY_PATH /usr/lib/llvm-3.4/lib:${CROSS_ROOT}/lib
ENV MAC_SDK_VERSION 10.10
ENV MACOSX_DEPLOYMENT_TARGET ${MAC_SDK_VERSION}
ENV OSXCROSS_HOST x86_64
ENV OSXCROSS_SDK=${CROSS_ROOT}/SDK/MacOSX${MAC_SDK_VERSION}.sdk
ENV OSXCROSS_TARGET=x86_64h-apple-darwin14
ENV OSXCROSS_TARGET_DIR ${CROSS_ROOT}

RUN apt-get update && \
    apt-get install -y --force-yes clang-3.4 llvm-3.4-dev automake autogen \
    libtool libxml2-dev uuid-dev libssl-dev bash \
    patch make tar xz-utils bzip2 gzip sed cpio

RUN cd / && \
    curl -L https://github.com/tpoechtrager/osxcross/archive/master.tar.gz | tar xvz && \
    ls -lah && \
    pwd && \
    cd /osxcross-master/ && \
    curl -L -o tarballs/MacOSX${MAC_SDK_VERSION}.sdk.tar.xz https://www.dropbox.com/s/yfbesd249w10lpc/MacOSX${MAC_SDK_VERSION}.sdk.tar.xz && \
    ln -s /usr/bin/clang-3.4 /usr/bin/clang && \
    ln -s /usr/bin/clang++-3.4 /usr/bin/clang++ && \
    echo | SDK_VERSION=${MAC_SDK_VERSION} OSX_VERSION_MIN=10.6 ./build.sh && \
    mv /osxcross-master/target ${CROSS_ROOT} && \
    mkdir -p ${CROSS_ROOT}/lib && \
    rm -rf /osxcross-master

ENV DEFAULT_DOCKCROSS_IMAGE dockcross/darwin-x64
