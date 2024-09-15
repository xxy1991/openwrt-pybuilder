#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@Time    : 2024-09-15 15:00
@Author  : xxy
@Email   : xxy@lesscode.dev
"""

import copy
import json
import logging
from functools import cmp_to_key
from pathlib import Path
from typing import Callable, List


def __cmp_func(src: List[str]) -> Callable[[str, str], int]:
    def func(x: str, y: str) -> int:
        # if x.startswith('-') and not y.startswith('-'):
        #     return -1
        # if y.startswith('-') and not x.startswith('-'):
        #     return 1
        return src.index(x) - src.index(y)

    return func


def _merge(x: List[str], y: List[str]) -> List[str]:
    merged = x + y
    return sorted(set(merged), key=cmp_to_key(__cmp_func(merged)))


def _remove_reverse(x: List[str]) -> List[str]:
    result = list(x)
    remove_items = []
    for item in result:
        if item.startswith("-"):
            remove_items.append(item[1:])
    for item in remove_items:
        if item in result:
            result.remove(item)
            result.remove("-" + item)
    return result


class Config(object):
    def __init__(self, path: Path = None):
        """Constructor"""
        data = dict(
            name=None,
            version="23.05.4",
            target="x86",
            subtarget="64",
            profile=None,
            env_list=None,
            includes=[],
            packages=[],
            files=[],
            disabled_services=[],
        )
        self._data = data
        self.load(path)

    def load(self, path: Path):
        if path is None:
            return
        if not path.is_file():
            return
        json_doc = json.loads(path.read_text())
        if "name" in json_doc:
            self._data["name_"] = json_doc["name"]
        if "version" in json_doc:
            self._data["version"] = json_doc["version"]
        if "target" in json_doc:
            self._data["target"] = json_doc["target"]
        if "subtarget" in json_doc:
            self._data["subtarget"] = json_doc["subtarget"]
        if "profile" in json_doc:
            self._data["profile"] = json_doc["profile"]
        if "env-file" in json_doc:
            self._data["env_file"] = json_doc["env-file"]
        if "includes" in json_doc:
            self._data["includes"] = json_doc["includes"]
        if "packages" in json_doc:
            self._data["packages"] = _remove_reverse(
                _merge(self.packages, json_doc["packages"])
            )
        if "files" in json_doc:
            self._data["files"] = _merge(self.files, json_doc["files"])
        if "disabled_services" in json_doc:
            self._data["disabled_services"] = _merge(
                self.disabled_services, json_doc["disabled_services"]
            )
        if len(self.includes) <= 0:
            return

        def map_files(root_path: Path, sub_path: Path) -> Callable[[str], str]:
            def _(x: str) -> str:
                if x.startswith(str(root_path)):
                    return x
                new_path = str(sub_path.joinpath(x))
                if x.endswith("/") and not new_path.endswith("/"):
                    new_path += "/"
                return new_path

            return _

        templates_path = Path(__file__).parent.joinpath("resources/templates")
        templates_config = Config()
        for template in self.includes:
            template_path = templates_path.joinpath(f"{template}")
            template_json_path = template_path.joinpath("config.json")
            if template_json_path.exists():
                template_config = Config(template_json_path)
                template_config.files = list(
                    map(map_files(templates_path, template_path), template_config.files)
                )
                templates_config.merge(template_config)
                logging.debug(f"{template}:{templates_config.packages}")
        self.merge(templates_config, True)
        logging.debug(f"self:{self.packages}")

    def merge(self, other: "Config", reverse=False) -> None:
        prior = self
        next_ = other
        if reverse:
            prior = other
            next_ = self
        self.packages = _remove_reverse(_merge(prior.packages, next_.packages))
        self.files = _merge(prior.files, next_.files)
        self.disabled_services = _merge(
            prior.disabled_services, next_.disabled_services
        )

    def __add__(self, other: "Config") -> "Config":
        config = copy.deepcopy(self)
        config.merge(other)
        return config

    @property
    def name(self) -> str:
        return self._data["name_"]

    @name.setter
    def name(self, value: str) -> None:
        self._data["name_"] = value

    @property
    def version(self) -> str:
        return self._data["version"]

    @version.setter
    def version(self, value: str) -> None:
        self._data["version"] = value

    @property
    def target(self) -> str:
        return self._data["target"]

    @target.setter
    def target(self, value: str) -> None:
        self._data["target"] = value

    @property
    def subtarget(self) -> str:
        return self._data["subtarget"]

    @subtarget.setter
    def subtarget(self, value: str) -> None:
        self._data["subtarget"] = value

    @property
    def profile(self) -> str:
        return self._data["profile"]

    @profile.setter
    def profile(self, value: str) -> None:
        self._data["profile"] = value

    @property
    def env_file(self) -> str:
        return self._data["env_file"]

    @env_file.setter
    def env_file(self, value: str) -> None:
        self._data["env_file"] = value

    @property
    def includes(self) -> List[str]:
        return self._data["includes"]

    @includes.setter
    def includes(self, value: List[str]) -> None:
        self._data["includes"] = value

    @property
    def packages(self) -> List[str]:
        return self._data["packages"]

    @packages.setter
    def packages(self, value: List[str]) -> None:
        self._data["packages"] = value

    @property
    def files(self) -> List[str]:
        return self._data["files"]

    @files.setter
    def files(self, value: List[str]) -> None:
        self._data["files"] = value

    @property
    def disabled_services(self) -> List[str]:
        return self._data["disabled_services"]

    @disabled_services.setter
    def disabled_services(self, value: List[str]) -> None:
        self._data["disabled_services"] = value

    def to_dict(self) -> dict:
        return self._data
