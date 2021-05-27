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
