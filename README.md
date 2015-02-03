# MinGW-w64 Builds

Windows builds of popular libraries using the MinGW-w64 compiler.

---

## Introduction

MinGW-w64 Builds uses:
  - The [MinGW-w64](http://mingw-w64.sourceforge.net) compiler suite
  - MinGW-w64's [MSYS build](http://sourceforge.net/projects/mingwbuilds/files/external-binary-packages/)
  - Mingw-builds (available [here](http://mingw-w64.sourceforge.net/download.php))

## Why not Cygwin?

Cygwin builds libraries that depend on the Cygwin DLL.  While the Cygwin
project is awesome, that's a dependency I'd rather avoid.

## Why not MSYS2?

MSYS2 is a (poorly-named) fork of Cygwin with the same drawback.

## Why not TDM-GCC?

I've encountered bugs; whether they're due to my setup I can't say, but I can
say I don't encounter them using MinGW-w64.

## Why not Win-builds?

[Win-builds](http://win-builds.org/) is awesome, but they don't have a Python
package, and the package manager doesn't run on Windows XP, which makes me
worry about the rest of the libraries.

## Why not cross-compile?

This is actually my second attempt to build popular libraries for Windows use.
The original idea - which worked very well - was to cross-compile the libraries
for Windows on Linux.  Unfortunately, GObject Introspection is too difficult to
build this way.  It builds a Python module in C that it then uses to generate
typelib files; this process requires a cross-compiled Python, but this Python
will not run in the native environment, so the typelib files cannot be
generated.  Essentially, and as far as I know, it is impossible to
cross-compile GObject Introspection as a result.

## Design

The original design had multiple phases; everything would be cleaned, source
would be downloaded and unpacked, everything would be built, packages with
circular dependencies would be rebuilt, then the final archive would be built.

While this saved a lot of code, it was painful for development because there
wasn't an easy way to build an individual package.  The current design has
self-contained scripts, so if updates or fixes are needed, it's easy to update
the build script and rebuild.

Dependencies and the 2nd build phase are a different issue.  I'd like to
transition to a
[makepkg](https://wiki.archlinux.org/index.php/makepkg)-compatible setup, which
comes with a whole host of benefits: source verification, dependency checking,
etc.  The 2nd build phase will probably continue to build on that, just as it
builds on the current build system, but we'll see what happens once we get
there.

## Usage

Download and install MinGW-w64 (I've only used and tested the 32-bit version
because I want the best compatibility).  Do the same for MinGW-w64's MSYS build
and Mingw-builds.  I installed MinGW-w64 at `C:\mingw-w64` and MSYS at
`C:\msys`.  Mingw-builds installs inside of the MinGW-w64 folder (unless you
change it, but why...).

Open a terminal and run `bash`.  I installed
[http://code.google.com/p/mintty](mintty) and created a shortcut where it calls
`bash` for this, but you can use `cmd` or
[http://sourceforge.net/projects/console](Console 2), whatever suits you.

Edit `config.sh` and set `MINGW64_DIR` to the location at which you installed
MinGW-w64.  Then run `build.sh`.  After a while, it will finish building all
the libraries (located in the `build` subfolder, unless you changed it in
`config.sh`).  It will then build the `mingw-builds.tar.xz` archive, as a
matter of convenience.

