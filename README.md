# nginx-ntlm-module

The NTLM module allows proxying requests with [NTLM Authentication](https://en.wikipedia.org/wiki/Integrated_Windows_Authentication). The upstream connection is bound to the client connection once the client sends a request with the "Authorization" header field value starting with "Negotiate" or "NTLM". Further client requests will be proxied through the same upstream connection, keeping the authentication context.

## How to use

> Syntax:  ntlm [connections];
> Default: ntlm 100;
> Context: upstream


```nginx
upstream http_backend {
    server 127.0.0.1:8080;

    ntlm;
}

server {
    ...

    location /http/ {
        proxy_pass http://http_backend;
        # next 2 settings are required for the keepalive to work properly
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
}
```

The connections parameter sets the maximum number of connections to the upstream servers that are preserved in the cache.

> Syntax:  ntlm_timeout timeout;
> Default: ntlm_timeout 60s;
> Context: upstream

Sets the timeout during which an idle connection to an upstream server will stay open.

## Pre-built Packages (Ubuntu / Debian)

Pre-built packages for this module are freely available from the GetPageSpeed repository:

```bash
# Install the repository keyring
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://extras.getpagespeed.com/deb-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/getpagespeed.gpg >/dev/null

# Add the repository (Ubuntu example - replace 'ubuntu' and 'jammy' for your distro)
echo "deb [signed-by=/etc/apt/keyrings/getpagespeed.gpg] https://extras.getpagespeed.com/ubuntu jammy main" \
  | sudo tee /etc/apt/sources.list.d/getpagespeed-extras.list

# Install nginx and the module
sudo apt-get update
sudo apt-get install nginx nginx-module-ntlm
```

The module is automatically enabled after installation. Supported distributions include Debian 12/13 and Ubuntu 20.04/22.04/24.04 (both amd64 and arm64). See [the complete setup instructions](https://apt-nginx-extras.getpagespeed.com/apt-setup/).

## Build

Follow the instructions from [Building nginx from Sources](http://nginx.org/en/docs/configure.html) and add the following line to the configure command

```bash
./configure \
    --add-module=../nginx-ntlm-module
```

To build this as dynamic module run this command

```bash
./configure \
    --add-dynamic-module=../nginx-ntlm-module
```

## Tests

In order to run the tests you need nodejs and perl installed on your system

```bash
# install the backend packages
npm install -C t/backend

# instal the test framework
cpan Test::Nginx

# set the path to your nginx location
export PATH=/opt/local/nginx/sbin:$PATH

prove -r t
```


## Acknowledgments

- This module is using most of the code from the original nginx keepalive module.
- DO NOT USE THIS IN PRODUCTION. [**Nginx Plus**](https://www.nginx.com/products/nginx/) has support for NTLM.

## Authors

* Gabriel Hodoroaga ([hodo.dev](https://hodo.dev))

## TODO

- [x] Add tests
- [x] Add support for multiple workers
- [x] Drop the upstream connection when the client connection drops.
- [ ] Add travis ci
