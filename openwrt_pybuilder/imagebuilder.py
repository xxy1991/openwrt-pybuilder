#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@Time    : 2020-08-31 22:52
@Author  : xxy
@Email   : xxy@lesscode.dev
"""

import argparse
import random
import shutil
import string
from pathlib import Path
from invoke import run
from openwrt_pybuilder.config import Config


class OpenwrtImageBuilder(object):
    def __init__(self, config: Config):
        """Constructor"""
        if config is None:
            raise RuntimeError("Config is required!")
        self._config = config

    @property
    def config(self) -> Config:
        return self._config

    def _check_image_name(self) -> None:
        if self.config.name is None:
            raise RuntimeError("Image name is required!")

    def copy_files(self, dst_path: str) -> None:
        if dst_path is None:
            raise RuntimeError("Destination path is required!")

        templates_path = Path(__file__).parent.joinpath("resources/templates")
        shutil.copy(f"{templates_path}/docker-entrypoint.sh", dst_path)
        with open(f"{templates_path}/Dockerfile.tpl", "r") as file:
            content = file.read()
        template = string.Template(content)
        new_content = template.substitute(
            image=f"openwrt/imagebuilder:{self.config.target}-{self.config.subtarget}-{self.config.version}"
        )
        with open(f"{dst_path}/Dockerfile", "w") as file:
            file.write(new_content)

        for src_path in self.config.files:
            src_path_obj = Path(src_path)
            if not src_path_obj.exists():
                raise RuntimeError(f"Source path: {src_path} must exists!")
            if src_path_obj.is_dir():
                run(f"cp -r {src_path} {dst_path}/")
            elif src_path_obj.is_file():
                run(f"cp {src_path} {dst_path}/")

    def build_docker(self):
        self._check_image_name()
        image_name = self.config.name
        run(f"docker build -t openwrt:{image_name} ./{image_name}-temp")

    def build_image(self):
        self._check_image_name()
        image_name = self.config.name
        random_letters = "".join(random.choices(string.ascii_letters, k=6))
        container_name = f"{image_name}_{random_letters}"
        self._container_name = container_name
        if self.config.env_file is None:
            raise RuntimeError("Env file is required!")
        env_file = self.config.env_file

        packages = f"PACKAGES={' '.join(self.config.packages)}"
        files = "FILES=files/"
        disabled_services = (
            f"DISABLED_SERVICES={' '.join(self.config.disabled_services)}"
        )
        args = f'"{packages}" "{files}" "{disabled_services}"'
        if self.config.profile is not None:
            args = f'PROFILE="{self.config.profile}" {args}'

        bin_path = Path(f"./{image_name}-bin")
        if not bin_path.exists():
            bin_path.mkdir()

        cache_path = Path("./cache")
        if not cache_path.exists():
            cache_path.mkdir()

        run(
            f"docker run --name openwrt-{container_name} "
            + f"--env-file {env_file} "
            + f'--mount type=bind,source="$(pwd)"/{image_name}-bin,target=/builder/bin '
            + f'--mount type=bind,source="$(pwd)"/cache,target=/builder/dl '
            + f"openwrt:{image_name} {args}"
        )

    @property
    def base_dir(self) -> str:
        return f"bin/targets/{self.config.target}/{self.config.subtarget}"

    @property
    def file_name(self) -> str:
        return f"openwrt-{self.config.version}-{self.config.target}-{self.config.subtarget}"

    # obsoleted
    def cp_target(self, remote_path: str = None, file_path: str = None):
        self._check_image_name()
        image_name = self.config.name
        if remote_path is None:
            raise RuntimeError("Remote path is required!")
        if file_path is None:
            raise RuntimeError("File path is required!")
        run(f'docker cp openwrt-{image_name}:"{remote_path}" "{file_path}"')

    # obsoleted
    def cp_squashfs_qcow2(self):
        self._check_image_name()
        image_name = self.config.name
        # self.cp_squashfs_img()
        file_name = f"{image_name}-squashfs-combined.img.gz"
        run(f"gunzip {file_name}")
        file_name = Path(file_name).stem
        run(f"qemu-img resize -f raw {file_name} 300M")
        run(f"qemu-img convert -f raw -O qcow2 {file_name} {image_name}.qcow2")
        run(f"mv {file_name} {image_name}.img")
        run(f"rm -f {image_name}.img.gz")
        run(f"gzip {image_name}.img")

    def remove_instance(self):
        if self._container_name is not None:
            run(f"docker container stop openwrt-{self._container_name}")
            run(f"docker container rm openwrt-{self._container_name}")


def get_args(args=None):
    parser = argparse.ArgumentParser(description="OpenWRT image builder.")
    parser.add_argument("image name", help="the image's name")
    parser.add_argument("-V", help="the distribution's major version")
    parser.add_argument("-C", "--config", help="config file path")
    parser.add_argument("-M", "--manual", action="store_true", help="manual mode")

    if args is not None:
        return parser.parse_args(args)
    return parser.parse_args()
