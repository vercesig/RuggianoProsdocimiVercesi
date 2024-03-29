FROM ubuntu:latest

RUN apt update && \
    apt install -y autoconf automake make libtool pkg-config g++ gcc jq lcov protobuf-compiler \
        vim-common libboost-all-dev libboost-all-dev libcurl4-openssl-dev libprotobuf-dev git \
        libgeos-dev libgeos++-dev liblua5.2-dev libspatialite-dev libsqlite3-dev lua5.2 \
        libsqlite3-mod-spatialite libsodium-dev libpgm-dev libczmq-dev patch wget && \
    cd / && \
    git clone --single-branch --depth 1 https://github.com/kevinkreiser/prime_server && \
    cd prime_server && git submodule update --init --recursive && \
    ./autogen.sh && ./configure && make install -j$(nproc) && cd .. && \
    git clone --single-branch --depth 1 https://github.com/valhalla/valhalla && \
    cd valhalla && git submodule update --init --recursive && \
    ./autogen.sh && ./configure --prefix=/opt && make install -j$(nproc) && \
    apt remove -y autoconf automake make libtool pkg-config g++ gcc jq lcov protobuf-compiler \
        vim-common libboost-all-dev libboost-all-dev libcurl4-openssl-dev libprotobuf-dev git \
        libgeos-dev libgeos++-dev liblua5.2-dev libspatialite-dev libsqlite3-dev lua5.2 \
        libsqlite3-mod-spatialite libsodium-dev libpgm-dev libczmq-dev patch wget software-properties-common && \
    apt autoremove -y && rm -r /valhalla && rm -r /prime_server && \
    apt install -y python libboost-*1.58.0 liblua5.2-0 libspatialite7 \
        libsqlite3-mod-spatialite libprotobuf9v5 libczmq3 libcurl3
