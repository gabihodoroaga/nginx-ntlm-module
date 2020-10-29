#!/bin/bash

# download nginx
curl -OL http://nginx.org/download/nginx-1.19.3.tar.gz
tar -xvzf nginx-1.19.3.tar.gz && rm nginx-1.19.3.tar.gz

# download PCRE library
curl -OL https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
tar -xvzf pcre-8.44.tar.gz && rm pcre-8.44.tar.gz

# download OpenSSL
curl -OL https://www.openssl.org/source/openssl-1.1.1h.tar.gz
tar -xvzf openssl-1.1.1h.tar.gz && rm openssl-1.1.1h.tar.gz 

# download zlib
curl -OL https://zlib.net/zlib-1.2.11.tar.gz
tar -xvzf zlib-1.2.11.tar.gz && rm zlib-1.2.11.tar.gz
