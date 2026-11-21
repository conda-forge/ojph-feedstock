#!/bin/bash
set -exuo pipefail

# Link the shared libojph from the host environment, found through its
# ojph.pc, instead of building the fork of OpenJPH from source.
export OJPH_SYSTEM_LIBOJPH=1
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"
python -m pip install . -vv --no-deps --no-build-isolation
