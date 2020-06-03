Credits to original base project: https://github.com/jessfraz/irssi

## Irssi Tor Docker Container for arm64v8
A minimal arm64v8 [Docker](https://www.docker.com/) image to run the IRC client [Irssi](https://irssi.org/) on [Tor](https://www.torproject.org/).

### Supported Tags and Respective `Dockerfile` Links

- `latest` ([*/Dockerfile*](https://github.com/splitstrikestream/irssi-tor-docker/tree/master/Dockerfile))

### How to use this image

Because it is unlikely any two irssi users have the same configuration preferences, this image does not include an irssi configuration. To configure irssi to your liking, please refer to [upstream's excellent (and comprehensive) +documentation](http://irssi.org/documentation).

Be sure to also checkout the [awesome scripts](https://github.com/irssi/scripts.irssi.org) you can download to customize your irssi configuration.

#### Build from Sources

Instead of installing the image from Docker Hub, you can build the image from sources if you prefer:

    $ git clone https://github.com/splitstrikestream/arm-dockerfiles
    $ cd arm-dockerfiles/arm64v8-alpine-tor-irssi
    $ docker build -t splitstrikestream/arm64v8-alpine-tor-irssi .

#### Directly via bind mount

On a Linux system, build and launch a container named tor-irssi like this:

```
$ docker run -it --name tor-irssi -e TERM -u $(id -u):$(id -g) \
    --log-driver=none \
    -v $HOME/.irssi:/home/user/.irssi:ro \
    -v /etc/localtime:/etc/localtime:ro \
    splitstrikestream/arm64v8-alpine-tor-irssi
```

We specify --log-driver=none to avoid storing useless interactive terminal data.

irssi runs as user (1001:1001), so in order for the user to have acess to .irssi files, the host machine must to set permissions accordingly. You can, for instance, change owner `chown 1001:1001 -R ~/.irssi` or just set permissive permissions as needed.

#### Connecting to Freenode using Tor

You cannot connect to usual freenode servers while using Tor, but you can use its hidden service.

In order to do that, follow the steps belloe:

###### 1. Generate a client certificate and put it where irssi can find it

```
$ openssl req -x509 -sha256 -new -newkey rsa:4096 -days 1000 -nodes \
                -out FreenodeTor.pem -keyout FreenodeTor.pem

Generating a 4096 bit RSA private key
...
Common Name (e.g. server FQDN or YOUR name) []: mary

$ mkdir -p ~/.irssi/certs
$ mv FreenodeTor.pem ~/.irssi/certs/
```

Set the "Common Name" to the registered nick (here, "mary"), the rest of the fields can be left blank (i.e. type .), but can probably be set to whatever you desire.

Also note the validity period should be whatever makes sense to you; here we have set it to 1000 days.

###### 2. Print out the certificate's fingerprint; remember it

```
$ openssl x509 -in ~/.irssi/certs/FreenodeTor.pem -outform der | sha1sum -b | cut -d' ' -f1
```

###### 3. Connect to freenode over the normal internet and associate the certificate with the nick

```
$ irssi
[(status)] /connect irc.freenode.net
[(status)] /msg NickServ identify <your password here>
[(status)] /msg NickServ CERT ADD <fingerprint from step 3.>
```

###### 4. Add a new network and server to irssi

```
[(status)] /network add -sasl_username <nick> -sasl_password <password> -sasl_mechanism EXTERNAL FreenodeTor
[(status)] /server add -ssl -ssl_cert ~/.irssi/certs/FreenodeTor.pem -net FreenodeTor zettel.freenode.net 6697
```

###### 5. Add some info leakage prevention configuration

```
[(status)] /ignore * CTCPS
[(status)] /save
[(status)] /quit
```

###### 6. Check that the irssi config contains something like the following:

```
servers = (
    {
        address = "zettel.freenode.net";
        chatnet = "FreenodeTor";
        port = "6697";
        use_tls = "yes";
        tls_cert = "~/.irssi/certs/FreenodeTor.pem";
        tls_verify = "no";
        autoconnect = "no";
    }
);

chatnets = {
    FreenodeTor = {
        type = "IRC";
        max_kicks = "1";
        max_msgs = "4";
        max_whois = "1";
        sasl_mechanism = "external";
        sasl_username = "<your nick>";
        sasl_password = "<your password>";
    };
};

settings = {
    core = { real_name = "<your nick>"; user_name = "<your nick>"; nick = "<your nick>"; };
};

ignores = ( { level = "CTCPS"; } );
```

###### 7. Connect

```
[(status)] /connect FreenodeTor
```

#### Adding New Proxies to ProxyChains

```Dockerfile
FROM splitstrikestream/irssi-tor

RUN echo 'socks4 myproxy.example.com 8080' >> $PROXYCHAINS_CONF
```