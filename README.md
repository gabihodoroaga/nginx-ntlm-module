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
$ ./configure \
    --add-module=../nginx-ntlm-module
```

## Releases 

Platform          | File 
----------------  | --------------------
MacOS             | [nginx-macos.tar.gz](https://github.com/gabihodoroaga/nginx-ntlm-module/releases/download/v1.19.3/nginx-macos.tar.gz)
Linux             | [nginx-linux.tar.gz](https://github.com/gabihodoroaga/nginx-ntlm-module/releases/download/v1.19.3/nginx-linux.tar.gz)
Windows           | [nginx-win64.zip](https://github.com/gabihodoroaga/nginx-ntlm-module/releases/download/v1.19.3/nginx-win64.zip)

## Acknowledgments

- This module is using most of the code from the original nginx keepalive modules.
- DO NOT USE THIS IN PRODUCTION. The [**Nginx Plus**](https://www.nginx.com/products/nginx/) has support for NTLM. 

## Authors 

* Gabriel Hodoroaga ([hodo.dev](https://hodo.dev))

## TODO

[x] Add tests
[x] Add support for multiple workers
[x] Drop the upstream connection when the client connection drops.
