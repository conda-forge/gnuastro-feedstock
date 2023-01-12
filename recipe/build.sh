#!/usr/bin/env bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./bootstrapped/build-aux

echo "DEBUG: libtool" && libtool --version
./configure --prefix=${PREFIX}
make -j${CPU_COUNT}
echo "DEBUG: config.log" && cat config.log
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check || (cat tests/test-suite.log && echo "ERROR: make check failed, see above" && exit 1)
fi
make install
