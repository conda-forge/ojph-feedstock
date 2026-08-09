setlocal EnableDelayedExpansion

:: Build the vendored ojph fork of OpenJPH as a static library, mirroring
:: what the project's tools/build_openjph.py does for the wheels.
cmake -S "%SRC_DIR%\subprojects\ojph" -B "%SRC_DIR%\build-ojph" ^
  %CMAKE_ARGS% ^
  -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
  -DOJPH_BUILD_EXECUTABLES=OFF ^
  -DOJPH_BUILD_TESTS=OFF ^
  -DOJPH_ENABLE_TIFF_SUPPORT=OFF ^
  -DOJPH_REQUIRE_HWY=ON ^
  -DOJPH_HWY_INCLUDE_DIR="%LIBRARY_PREFIX%\include" ^
  -DCMAKE_INSTALL_PREFIX="%SRC_DIR%\openjph-install"
if errorlevel 1 exit 1
cmake --build "%SRC_DIR%\build-ojph" --parallel %CPU_COUNT%
if errorlevel 1 exit 1
cmake --install "%SRC_DIR%\build-ojph"
if errorlevel 1 exit 1

set "OPENJPH_INSTALL_DIR=%SRC_DIR%\openjph-install"
:: setup.py locates the hwy import library via CONDA_PREFIX\Library;
:: in conda-build the host prefix is PREFIX, so point it there for the
:: pip step (the hwy kernels dispatch through the Highway library).
set "CONDA_PREFIX=%PREFIX%"
python -m pip install . -vv --no-deps --no-build-isolation
if errorlevel 1 exit 1
