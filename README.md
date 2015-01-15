# MinGW-w64 Builds

Windows builds of popular libraries using the MinGW-w64 compiler.

---

MinGW-w64 Builds is the latest chapter in my quest to build a sufficient stack
of libraries suitable for compiling \*nix software on Windows.  The original
idea, which worked very well, was to cross-compile the libraries for Windows on
Linux.  Unfortunately, GObject Introspection is too difficult to build this
way.  It builds a Python module in C that it then uses to generate typelib
files; this process requires a cross-compiled Python, but this Python will not
run in the native environment, so the typelib files cannot be generated.

I then endeavored to build the libraries natively on Windows using MSYS and
TDM-GCC.  However, there are various bugs building gettext that I was unable to
surmount (i.e., I was unwilling to patch 3 identical versions of xsize.c and
xsize.h so that gettext would no longer -- incorrectly -- rely on specific
inlining behavior).

In this version, I am attempting to use Cygwin and the included 32-bit
MinGW-w64 compiler.  Fingers crossed!

