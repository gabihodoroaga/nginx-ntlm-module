# Build using docker

This document describes the steps to follow in order to build this modules using docker 

## alpine - static

```bash
cd alpine/static 
# build
docker build -t nginx-ntlm .

# test 
docker run --rm -it -p 8080:80 \
        -v $(PWD)/nginx.conf:/etc/nginx/nginx.conf \
        nginx-ntlm

# if nginx starts without error you are good to go
```

## alpine - dynamic 

```bash
cd alpine/dynamic

# build 
docker build -t nginx-ntlm-dynamic .

# test
docker run --rm -it -p 8080:80 \
        -v $(PWD)/nginx.conf:/etc/nginx/nginx.conf \
        nginx-ntlm-dynamic

# if nginx starts without error you are good to go
```

## openresty alpine  - using official build image

```bash
docker build -t openresty-ntlm \
    -f alpine/Dockerfile \
    --build-arg RESTY_CONFIG_OPTIONS_MORE="--add-module=../nginx-ntlm-module" \
    --build-arg RESTY_EVAL_PRE_CONFIGURE="curl -L https://github.com/gabihodoroaga/nginx-ntlm-module/archive/refs/tags/v1.19.3-beta.1.tar.gz -o nginx-ntlm-module.tar.gz && tar -xvzf nginx-ntlm-module.tar.gz && mv nginx-ntlm-module-1.19.3-beta.1 nginx-ntlm-module" \
    https://github.com/openresty/docker-openresty.git
```

## openresty alpine - static

```bash
cd openresty/alpine/static

# build
docker build -t openresty-ntlm .

# test
docker run --rm -it -p 8080:80 \
        -v $(PWD)/test/default.conf:/etc/nginx/conf.d/default.conf \
        openresty-ntlm

# if nginx starts without error you are good to go
```

## openresty alpine - dynamic

```bash
cd openresty/alpine/dynamic

# build
docker build -t openresty-ntlm-dynamic .

# test
docker run --rm -it -p 8080:80 \
        -v $(PWD)/test/default.conf:/etc/nginx/conf.d/default.conf \
        -v $(PWD)/test/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf \
        openresty-ntlm-dynamic

# if nginx starts without error you are good to go
```
