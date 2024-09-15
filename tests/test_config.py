#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@Time    : 2020-01-31 18:35
@Author  : xxy
@Email   : xxy@lesscode.dev

Tests for openwrt_pybuilder.tool.
"""
import json
import unittest
from importlib import import_module
from pathlib import Path
from types import ModuleType
from typing import List, Tuple

from openwrt_pybuilder.imagebuilder import Config


class ConfigTest(unittest.TestCase):

    def setUp(self) -> None:
        self.config1 = Config(Path("test1.json"))
        self.config2 = Config(Path("test2.json"))
        self.config3 = self.config1 + self.config2

    def test_merge(self) -> None:
        config1 = self.config1
        config2 = self.config2
        config3 = self.config3
        self.assertEqual(config1.version, "19.07.8")
        print(config1.to_dict())
        print(config2.to_dict())
        print(config3.to_dict())

    def test_hs18ss(self) -> None:
        hs18ss = Config(Path("hs18ss.json"))
        json_doc = json.loads(Path("hs18ss.json").read_text())
        templates = json_doc['includes']

        template_modules: List[Tuple[str, ModuleType]] = list()
        packages: List[str] = list()
        for template in templates:
            template_module = import_module(
                f'openwrt_pybuilder.templates.build_{template}')
            template_modules.append((template, template_module))
            template_packages_func = getattr(template_module, 'get_packages')
            packages.extend(template_packages_func())
        packages.extend(json_doc['packages'])
        packages = sorted(set(packages), key=packages.index)
        self.assertEqual(hs18ss.packages, packages)
