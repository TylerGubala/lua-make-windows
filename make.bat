@echo off

if defined PROCESSOR_ARCHITECTURE (
    if /I "%PROCESSOR_ARCHITECTURE%"=="amd64" (
        set platform="64"
        call :setup
        call :build
        call :install
        echo "Successfully built Lua for windows 64-bit (amd64)"
        goto :eof
    )
    if /I "%PROCESSOR_ARCHITECTURE%"=="x86" (
        set platform="32"
        call :setup
        call :build
        call :install
        echo "Successfully built Lua for windows 32-bit (x86)"
        goto :eof
    )
)
if defined PROCESSOR_ARCHITECTUREW6432 (
    if /I "%PROCESSOR_ARCHITECTUREW6432%"=="amd64" (
        set platform="64"
        call :setup
        call :build
        call :install
        echo "Successfully built Lua for windows 64-bit (WOW6432)"
        goto :eof
    )
    if /I "%PROCESSOR_ARCHITECTUREW6432%"=="x86" (
        set platform="32"
        call :setup
        call :build
        call :install
        echo "Successfully built Lua for windows 32-bit (WOW6432)"
        goto :eof
    )
)
call :archinvalid
goto :eof

:archinvalid
echo "Your platform archetecture could not be determined: %platform%"
goto :eof

:vserror
echo "Visual Studio 2017 not installed, or the environment variable VS2017INSTALLDIR is not set, please remedy this and try again"
goto :eof

:setup
if defined VS2017INSTALLDIR (
    if defined platform (echo "Platform is defined") else (echo "Platform is not defined")
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
if not exist "%LOCALAPPDATA%\Lua" mkdir "%LOCALAPPDATA%\Lua"
if not exist "%LOCALAPPDATA%\Lua\include" mkdir "%LOCALAPPDATA%\Lua\include"
if not exist "%LOCALAPPDATA%\Lua\bin" mkdir "%LOCALAPPDATA%\Lua\bin"
if not exist "%LOCALAPPDATA%\Lua\src" mkdir "%LOCALAPPDATA%\Lua\src"
xcopy /y *.exe "%LOCALAPPDATA%\Lua"
xcopy /y *.dll "%LOCALAPPDATA%\Lua\bin"
xcopy /y *.h "%LOCALAPPDATA%\Lua\include"
xcopy /y *.c "%LOCALAPPDATA%\Lua\src"
echo.
echo "Your DLL and exe files are in %LOCALAPPDATA%\Lua"
echo.
echo "Append the above directory to path if you want to use lua from the command prompt"
echo.
echo.
goto :eof
