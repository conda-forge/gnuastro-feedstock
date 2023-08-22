#!/usr/bin/env bash
# Get an updated config.sub and config.guess

echo "DEBUG: manually untarring of source code:"
cd $SRC_DIR
tar -xf gnuastro-0.20.60-d994.tar.lz
cp gnuastro-0.20.60-d994/COPYING .
cd gnuastro-0.20.60-d994

# https://conda-forge.org/docs/maintainer/knowledge_base.html#cross-compilation
cp $BUILD_PREFIX/share/gnuconfig/config.* .

echo "DEBUG: libtool" && libtool --version
./configure --prefix=${PREFIX}
make -j${CPU_COUNT}
echo "DEBUG: config.log" && cat config.log
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check || (cat tests/test-suite.log && echo "ERROR: make check failed, see above" && exit 1)
fi
make install
