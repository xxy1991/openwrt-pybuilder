#!/usr/bin/env bash

VERSION='19.07.8'
ARCH=x86
BOARD=64

BASE_DIR=/data/openwrt-imagebuilder-$VERSION-$ARCH-$BOARD.Linux-x86_64
BASE_DIR=$BASE_DIR/bin/targets/$ARCH/$BOARD
FILE_NAME=openwrt-$VERSION-$ARCH-$BOARD-generic-rootfs.tar.gz
VMDK_NAME=openwrt-$VERSION-$ARCH-$BOARD-combined-ext4.vmdk

# build_docker(image_name)
build_docker(){
    if [ -z "$1" ]; then
        echo "Image name is required!"
        exit 1
    fi
    local image_name=$1

    docker build -t openwrt:$image_name ./$image_name-temp
}

# build_image(image_name, envfile, args)
build_image(){
    if [ -z "$1" ]; then
        echo "Image name is required!"
        exit 1
    fi
    local image_name=$1; shift

    if [ -z "$1" ]; then
        echo "Env file is required!"
        exit 1
    fi
    local envfile=$1; shift

    docker run --name openwrt-$image_name --env-file $envfile \
        openwrt:$image_name "$@"
}

# remove_instance(image_name)
remove_instance(){
    if [ -z "$1" ]; then
        echo "Image name is required!"
        exit 1
    fi
    local image_name=$1

    docker container stop openwrt-$image_name
    docker container rm openwrt-$image_name
}

# cp_rootfs(image_name, file_path)
cp_rootfs(){
    if [ -z "$1" ]; then
        echo "Image name is required!"
        exit 1
    fi
    local image_name=$1

    local path=${BASE_DIR}/${FILE_NAME}
    if [ -n "$2" ]; then path=$2; fi

    docker cp openwrt-$image_name:"$path" "$image_name.tar.gz"
}

# cp_vmdk(image_name, file_path)
cp_vmdk(){
    if [ -z "$1" ]; then
        echo "Image name is required!"
        exit 1
    fi
    local image_name=$1

    local path=${BASE_DIR}/${VMDK_NAME}
    if [ -n "$2" ]; then path=$2; fi

    docker cp openwrt-$image_name:"$path" "$image_name.vmdk"
}
