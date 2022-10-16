Tool to reproduce the [DSA-1571](https://www.debian.org/security/2008/dsa-1571)
([CVE-2008-0166](https://security-tracker.debian.org/tracker/CVE-2008-0166)).
Use only for testing purposes.

[![build](https://github.com/hoefling/dsa-1571/actions/workflows/build.yml/badge.svg)](https://github.com/hoefling/dsa-1571/actions/workflows/build.yml)

### Local build

```sh
docker build --platform linux/386 -t openssl/dsa-1571 .
```

### Generate example keys and CSRs

```sh
# if on 64bit machine, first simulate PIDMAX from a 32bit system:
echo 32768 > /proc/sys/kernel/pid_max
docker run --rm -v $(pwd):/io -it openssl/dsa-1571 gencsr
```

`gencsr` will generate keys of 512, 1024 and 2048 bits size,
run `openssl-vulnkey` over them to check they are compromised
and generate one CSR for each key.

Example output:
```
Generating RSA private key, 512 bit long modulus
......++++++++++++
.......++++++++++++
e is 65537 (0x10001)
COMPROMISED: 93750cf27b4628bc98f636a80dbbd7b6fbcb9caa debian-openssl-0.9.8c-x86-prng-bug-512.key
Generating RSA private key, 1024 bit long modulus
............................++++++
.......................................................................................++++++
e is 65537 (0x10001)
COMPROMISED: ee898364b64d182ba053f026a7d2961f0916067d debian-openssl-0.9.8c-x86-prng-bug-1024.key
Generating RSA private key, 2048 bit long modulus
........+++
......................+++
e is 65537 (0x10001)
COMPROMISED: b724c8256936fad04f50042dcb33f1f6f3ce9eee debian-openssl-0.9.8c-x86-prng-bug-2048.key
```

### Links

* [`openssl-blacklist`](https://sources.debian.org/src/openssl-blacklist/0.5-3/)
* [deb files](http://ftp.debian.org/debian/pool/main/o/openssl-blacklist/)
* [deb source](https://www.apt-browse.org/browse/debian/jessie/main/all/openssl-blacklist/0.5-3/)
