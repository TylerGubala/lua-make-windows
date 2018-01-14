# lua-make-windows
Build Script for Lua (windows)

A short script with some error printing; expanded version of https://blog.spreendigital.de/2015/01/16/how-to-compile-lua-5-3-0-for-windows/

Credit to the original author, Dennis D. Spreen

## Requirements

Should have Visual Studio 2017 installed on the computer

The Visual Studio developer command prompt environment is used to build Lua. Visual Studio Build tools should also be up to date.

## Usage

1) Place the make.bat file in the src folder of the extracted Lua folder

2) Open a command prompt

3) cd to the folder

4) type "make" and hit enter

5) Lua should build, afterwards you should be able to open a new command prompt and type "lua" to start a new interactive session
