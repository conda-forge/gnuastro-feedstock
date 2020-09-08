#!/usr/bin/env bash

echo "DEBUG: libtool" && libtool --version
./configure --prefix=${PREFIX}
make -j${CPU_COUNT}
echo "DEBUG: config.log" && cat config.log
make check || (cat tests/test-suite.log && echo "ERROR: make check failed, see above" && exit 1)
make install
