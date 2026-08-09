#!/bin/bash
set -exuo pipefail

# Build the vendored ojph fork of OpenJPH as a static library, mirroring
# what the project's tools/build_openjph.py does for the wheels (the sdist
# does not ship that helper). setup.py picks the install up from
# OPENJPH_INSTALL_DIR and links the archive into the extension.
cmake -S "${SRC_DIR}/subprojects/ojph" -B "${SRC_DIR}/build-ojph" \
  ${CMAKE_ARGS} \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DOJPH_BUILD_EXECUTABLES=OFF \
  -DOJPH_BUILD_TESTS=OFF \
  -DOJPH_ENABLE_TIFF_SUPPORT=OFF \
  -DOJPH_REQUIRE_HWY=ON \
  -DOJPH_HWY_INCLUDE_DIR="${PREFIX}/include" \
  -DCMAKE_INSTALL_PREFIX="${SRC_DIR}/openjph-install"
cmake --build "${SRC_DIR}/build-ojph" --parallel "${CPU_COUNT}"
cmake --install "${SRC_DIR}/build-ojph"

export OPENJPH_INSTALL_DIR="${SRC_DIR}/openjph-install"
# setup.py locates the shared libhwy (which the hwy kernels dispatch
# through) via CONDA_PREFIX; in conda-build the host prefix is PREFIX,
# so point it there for the pip step or the extension underlinks and
# fails at import with an undefined hwy symbol.
CONDA_PREFIX="${PREFIX}" python -m pip install . -vv --no-deps --no-build-isolation
