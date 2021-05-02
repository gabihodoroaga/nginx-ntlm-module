#!/bin/bash

cd nginx-1.19.3/

# update file auto/cc/msvc:16
# NGX_MSVC_VER=19.16
# CFLAGS="$CFLAGS -W4"

# update file auto/lib/openssl/makefile.msvc
#
#	perl Configure VC-WIN64A no-shared				
#   ...
#   if exist ms\do_win64a.bat (					
#		ms\do_win64a

auto/configure \
    --with-cc=cl \
    --builddir=objs \
    --with-debug \
    --prefix= \
    --conf-path=conf/nginx.conf \
    --pid-path=logs/nginx.pid \
    --http-log-path=logs/access.log \
    --error-log-path=logs/error.log \
    --sbin-path=nginx.exe \
    --with-cc-opt=-DFD_SETSIZE=1024 \
    --with-pcre=objs/lib/pcre-8.44 \
    --with-zlib=objs/lib/zlib-1.2.11 \
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
    --with-openssl=objs/lib/openssl-1.1.1h \
    --with-http_ssl_module \
    --with-mail_ssl_module \
    --with-stream_ssl_module \
    --add-module=../nginx-ntlm-module


# update file objs/Makefile
# remove next 5 lines after this line (sed does not exists in windows) 
# objs/nginx.8:	docs/man/nginx.8 objs/ngx_auto_config.h
