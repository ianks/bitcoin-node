FROM debian:jessie
MAINTAINER Ian Ker-Seymer <i.kerseymer@gmail.com>

ENV BITCOIN_VERSION v0.10.0

RUN mkdir -p /usr/src/bitcoin
WORKDIR /usr/src/bitcoin

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
  && apt-get install -y \
    autoconf \
    autotools-dev \
    bsdmainutils \
    build-essential \
    libboost-all-dev \
    libssl-dev \
    libtool \
    pkg-config \
    curl \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Download source code
RUN curl -SLO "https://github.com/bitcoin/bitcoin/archive/$BITCOIN_VERSION.tar.gz" \
  && tar xf $BITCOIN_VERSION.tar.gz -C /usr/src/bitcoin --strip-components=1

# Compile from source
RUN ./autogen.sh \
  && ./configure --disable-wallet \
  && make \
  && make install \
  && make check \
  && rm -rf /usr/src/bitcoin

EXPOSE 8333 8332
ADD ./bitcoin.conf /root/.bitcoin/bitcoin.conf

CMD ["bitcoind", "--printtoconsole"]
