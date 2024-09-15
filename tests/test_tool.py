#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@Time    : 2020-01-31 18:35
@Author  : xxy
@Email   : xxy@lesscode.dev

Tests for openwrt_pybuilder.tool.
"""

import unittest

from openwrt_pybuilder.tool import build, get_package


class ToolTest(unittest.TestCase):

    def setUp(self) -> None:
        build()
        get_package()
