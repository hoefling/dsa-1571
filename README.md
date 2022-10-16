Tool to reproduce the [DSA-1571](https://www.debian.org/security/2008/dsa-1571)
([CVE-2008-0166](https://security-tracker.debian.org/tracker/CVE-2008-0166)).
Use only for testing purposes.

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

### Links

* [`openssl-blacklist`](https://sources.debian.org/src/openssl-blacklist/0.5-3/)
* [deb files](http://ftp.debian.org/debian/pool/main/o/openssl-blacklist/)
* [deb source](https://www.apt-browse.org/browse/debian/jessie/main/all/openssl-blacklist/0.5-3/)
