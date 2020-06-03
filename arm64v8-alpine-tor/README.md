Credits to original base project: https://github.com/zuazo/alpine-tor-docker

## Alpine Tor Docker Container for arm64v8
A minimal arm64v8 [Docker](https://www.docker.com/) image with the [Tor](https://www.torproject.org/) daemon running in the background.

### Supported Tags and Respective `Dockerfile` Links

- `latest` ([*/Dockerfile*](https://github.com/splitstrikestream/arm64v8-alpine-tor-docker/tree/master/Dockerfile))

### This Container Includes

- [Tor](https://www.torproject.org/).
- [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) to run DNS queries through Tor.
- [ProxyChains-NG](https://github.com/rofl0r/proxychains-ng).
- `proxychains_wrapper` helper script. See below.

### How to Use This Image

#### Build from Sources

Instead of installing the image from Docker Hub, you can build the image from sources if you prefer:

    $ git clone https://github.com/splitstrikestream/arm-dockerfiles
    $ cd arm-dockerfiles/arm64v8-alpine-tor
    $ docker build -t splitstrikestream/arm64v8-alpine-tor .

#### Run an Application Under Tor

    $ docker run splitstrikestream/arm64v8-alpine-tor wget -O- https://check.torproject.org/

#### The `proxychains_wrapper` Script

This helper script starts the Tor daemon and runs the command passed in the arguments.

    / # proxychains_wrapper -h
    Usage:
      proxychains_wrapper [-h] [-u USER] COMMAND [...]

Example:

    / # proxychains_wrapper wget -O- https://check.torproject.org/

#### Creating Your Own Images

You can create your own images with the application that you want to run under Tor.

For example:

```Dockerfile
FROM splitstrikestream/arm64v8-alpine-tor

RUN apk add --update \
      nmap && \
    rm -rf /var/cache/apk/* && \
    adduser -D -s /bin/sh nmap

ENTRYPOINT ["/usr/bin/proxychains_wrapper", "-u", "nmap", "nmap"]
```

Then build and run the image:

    $ docker build -t <user>/nmap-tor .
    $ docker run <user>/nmap-tor -sT -Pn -n -sV -p 21,22,80 scanme.nmap.org
    Waiting for Tor to boot.............
    [proxychains] config file found: /etc/proxychains/proxychains.conf
    [proxychains] preloading /usr/lib/libproxychains4.so
    [proxychains] DLL init: proxychains-ng 4.8.1

    Starting Nmap 6.47 ( http://nmap.org ) at 2015-10-29 21:47 UTC
    Nmap scan report for scanme.nmap.org (224.0.0.1)
    Host is up (8.1s latency).
    PORT   STATE  SERVICE VERSION
    21/tcp closed ftp
    22/tcp open   ssh     (protocol 2.0)
    80/tcp open   http    Apache httpd 2.4.7 ((Ubuntu))

    Service detection performed. Please report any incorrect results at http://nmap.org/submit/ .
    Nmap done: 1 IP address (1 host up) scanned in 19.04 seconds

#### Adding New Proxies to ProxyChains

```Dockerfile
FROM splitstrikestream/arm64v8-alpine-tor

RUN echo 'socks4 myproxy.example.com 8080' >> $PROXYCHAINS_CONF
```

### Read-only Environment Variables Used at Build Time

* `DNSMASQ_CONF`: Dnsmasq configuration file path.
* `DNSMASQ_LOG_DIR`: [`s6-log`](http://skarnet.org/software/s6/s6-log.html) logs directory for the Dnsmasq daemon.
* `PROXYCHAINS_CONF`: ProxyChains configuration file path.
* `TOR_CONF`: Tor configuration file path.
* `TOR_LOG_DIR`: [`s6-log`](http://skarnet.org/software/s6/s6-log.html) logs directory for the Tor daemon.
