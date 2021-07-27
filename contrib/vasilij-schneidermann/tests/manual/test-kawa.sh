#!/bin/sh

# SPDX-FileCopyrightText: 2021 Vasilij Schneidermann
#
# SPDX-License-Identifier: CC0-1.0

rm -f /tmp/srfi-203.svg
rm -rf out
kawa --r7rs -d out -C srfi/203.sld
export CLASSPATH=./out
kawa --r7rs tests/manual/test-r7rs.scm
