#!/bin/sh

# SPDX-FileCopyrightText: 2021 Vasilij Schneidermann
#
# SPDX-License-Identifier: CC0-1.0

rm -f /tmp/srfi-203.svg
sagittarius -n -L. tests/manual/test-r7rs.scm
