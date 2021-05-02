#!/bin/bash

cd nginx-1.19.3/

./configure --with-debug \
            --prefix= \
            --conf-path=conf/nginx.conf \
            --pid-path=logs/nginx.pid \
            --http-log-path=logs/access.log \
            --error-log-path=logs/error.log \
            --with-pcre=../pcre-8.44 \
            --with-zlib=../zlib-1.2.11 \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_sub_module \
            --with-http_dav_module \
            --with-http_stub_status_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-mail \
            --with-stream \
            --with-openssl=../openssl-1.1.1h \
            --with-http_ssl_module \
            --with-mail_ssl_module \
            --with-stream_ssl_module \
            --add-module=../nginx-ntlm-module
