#!/bin/bash

# download nginx
git clone --branch release-1.19.3 https://github.com/nginx/nginx.git nginx-1.19.3

# create the folder for libraries
mkdir -p nginx-1.19.3/objs/lib

# download PCRE library
curl -OL https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
tar -xvzf pcre-8.44.tar.gz -C nginx-1.19.3/objs/lib && rm pcre-8.44.tar.gz

# download OpenSSL
curl -OL https://www.openssl.org/source/openssl-1.1.1h.tar.gz
tar -xvzf openssl-1.1.1h.tar.gz -C nginx-1.19.3/objs/lib && rm openssl-1.1.1h.tar.gz

# download zlib
curl -OL https://zlib.net/zlib-1.2.11.tar.gz
tar -xvzf zlib-1.2.11.tar.gz -C nginx-1.19.3/objs/lib && rm zlib-1.2.11.tar.gz
