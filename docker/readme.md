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

# if the nginx stats without error yout a good to go
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

# if the nginx stats without error yout a good to go
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

# if the nginx stats without error yout a good to go
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

# if the nginx stats without error yout a good to go
```

