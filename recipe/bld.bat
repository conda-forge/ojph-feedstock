setlocal EnableDelayedExpansion

:: Link the shared libojph from the host environment, found through its
:: ojph.pc, instead of building the fork of OpenJPH from source.
set "OJPH_SYSTEM_LIBOJPH=1"
set "PKG_CONFIG_PATH=%LIBRARY_PREFIX%\lib\pkgconfig"
python -m pip install . -vv --no-deps --no-build-isolation
if errorlevel 1 exit 1
