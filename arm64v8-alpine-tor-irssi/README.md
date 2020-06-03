Credits to original base project: https://github.com/jessfraz/irssi

### Irssi Tor Docker Container for arm64v8
A minimal arm64v8 [Docker](https://www.docker.com/) image to run the IRC client [Irssi](https://irssi.org/) on [Tor](https://www.torproject.org/).

#### Supported Tags and Respective `Dockerfile` Links

- `latest` ([*/Dockerfile*](https://github.com/splitstrikestream/irssi-tor-docker/tree/master/Dockerfile))

#### How to use this image

Because it is unlikely any two irssi users have the same configuration preferences, this image does not include an irssi configuration. To configure irssi to your liking, please refer to [upstream's excellent (and comprehensive) +documentation](http://irssi.org/documentation).

Be sure to also checkout the [awesome scripts](https://github.com/irssi/scripts.irssi.org) you can download to customize your irssi configuration.

##### Directly via bind mount

On a Linux system, build and launch a container named tor-irssi like this:

$ docker run -it --name tor-irssi -e TERM -u $(id -u):$(id -g) \
    --log-driver=none \
    -v $HOME/.irssi:/home/user/.irssi:ro \
    -v /etc/localtime:/etc/localtime:ro \
    splitstrikestream/arm64v8-alpine-tor-irssi

We specify --log-driver=none to avoid storing useless interactive terminal data.

##### Adding New Proxies to ProxyChains

```Dockerfile
FROM splitstrikestream/irssi-tor

RUN echo 'socks4 myproxy.example.com 8080' >> $PROXYCHAINS_CONF
```

##### Download the Image

    $ docker pull splitstrikestream/arm64v8-alpine-tor-irssi

#### Build from Sources

Instead of installing the image from Docker Hub, you can build the image from sources if you prefer:

    $ git clone https://github.com/splitstrikestream/arm-dockerfiles
    $ cd arm-dockerfiles/arm64v8-alpine-tor-irssi
    $ docker build -t splitstrikestream/arm64v8-alpine-tor-irssi .
