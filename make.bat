@echo off

if defined PROCESSOR_ARCHITECTURE (
    if /I "%PROCESSOR_ARCHITECTURE%"=="amd64" (
        set platform="64"
        call :setup
        call :build
        call :install
        echo Successfully built Lua for windows %PROCESSOR_ARCHITECTURE%
        goto :eof
    )
    if /I "%PROCESSOR_ARCHITECTURE%"=="x86" (
        set platform="32"
        call :setup
        call :build
        call :install
        echo Successfully built Lua for windows %PROCESSOR_ARCHITECTURE%
        goto :eof
    )
)
if defined PROCESSOR_ARCHITECTUREW6432 (
    if /I "%PROCESSOR_ARCHITECTUREW6432%"=="amd64" (
        set platform="64"
        call :setup
        call :build
        call :install
        echo Successfully built Lua for windows WOW6432 %PROCESSOR_ARCHITECTUREW6432%
        goto :eof
    )
    if /I "%PROCESSOR_ARCHITECTUREW6432%"=="x86" (
        set platform="32"
        call :setup
        call :build
        call :install
        echo Successfully built Lua for windows WOW6432 %PROCESSOR_ARCHITECTUREW6432%
        goto :eof
    )
)
call :archinvalid
goto :eof

:archinvalid
echo Your platform archetecture could not be determined: %platform%
goto :eof

:vserror
echo Visual Studio 2017 not installed, or the environment variable VS2017INSTALLDIR is not set, please remedy this and try again
goto :eof

:setup
if defined VS2017INSTALLDIR (
    call "%VS2017INSTALLDIR%\VC\Auxiliary\Build\vcvars%platform%"
    goto :eof
)
else (
    call :vserror
    goto :eof
)

:build
cl /MD /O2 /c /DLUA_BUILD_AS_DLL *.c
ren lua.obj lua.o
ren luac.obj luac.o
link /DLL /IMPLIB:lua.lib /OUT:lua.dll *.obj 
link /OUT:lua.exe lua.o lua.lib 
lib /OUT:lua-static.lib *.obj
link /OUT:luac.exe luac.o lua-static.lib
goto :eof

:install
set INSTALLDIR="%LOCALAPPDATA%\Lua"
if not exist "%INSTALLDIR%" mkdir "%INSTALLDIR%"
if not exist "%INSTALLDIR%\include" mkdir "%INSTALLDIR%\include"
if not exist "%INSTALLDIR%\bin" mkdir "%INSTALLDIR%\bin"
if not exist "%INSTALLDIR%\src" mkdir "%INSTALLDIR%\src"
xcopy /y *.exe "%INSTALLDIR%\bin"
xcopy /y *.dll "%INSTALLDIR%\bin"
xcopy /y *.h "%INSTALLDIR%\include"
xcopy /y *.c "%INSTALLDIR%\src"
mklink %INSTALLDIR%\lua.exe %INSTALLDIR%\bin\lua.exe
mklink %INSTALLDIR%\luac.exe %INSTALLDIR%\bin\luac.exe
echo.
echo The lua .exe and .dll files are in %INSTALLDIR%\bin
echo.
echo Append the above directory to path if you want to use lua from the command prompt
for /f "skip=2 tokens=3*" %%a in ('reg query HKCU\Environment /v PATH') do if [%%b]==[] ( setx PATH "%%~a;%INSTALLDIR%\bin" && set ok=1 ) else ( setx PATH "%%~a %%~b;%INSTALLDIR%\bin" && set ok=1 )
echo.
echo.
goto :eof
