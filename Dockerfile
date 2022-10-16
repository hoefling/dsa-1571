FROM i386/debian:bullseye as builder

COPY dsa-1571.patch /tmp

RUN apt update && apt install --yes --no-install-recommends build-essential:i386 curl:i386 git:i386 ca-certificates:i386 && update-ca-certificates

# download openssl-blacklist jessie debs
RUN curl -O http://ftp.debian.org/debian/pool/main/o/openssl-blacklist/openssl-blacklist_0.5-3_all.deb
RUN curl -O http://ftp.debian.org/debian/pool/main/o/openssl-blacklist/openssl-blacklist-extra_0.5-3_all.deb

# build OpenSSL with DSA-1571 vulnerability patch applied
RUN git clone --depth 1 --branch OpenSSL_0_9_8c https://github.com/openssl/openssl.git
WORKDIR /openssl
RUN git apply /tmp/dsa-1571.patch
RUN setarch i386 ./config -m32 --prefix=/root/.local --openssldir=/root/.local/openssl no-asm && make && make install_sw

FROM i386/debian:bullseye

COPY --from=builder /openssl-blacklist_0.5-3_all.deb /openssl-blacklist_0.5-3_all.deb
COPY --from=builder /openssl-blacklist-extra_0.5-3_all.deb /openssl-blacklist-extra_0.5-3_all.deb
COPY --from=builder /root/.local /root/.local
COPY gencsr /root/.local/bin

RUN apt update && apt install -y /openssl-blacklist_0.5-3_all.deb /openssl-blacklist-extra_0.5-3_all.deb

ENV PATH=/root/.local/bin:$PATH
