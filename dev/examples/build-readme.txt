Build.exe or build.linux etc. is a system built by Lars (L505) that builds
the powtils examples.

This is a command line program, but in the future a GUI wrapper can be made!

It is powered by the pwbuildutil.pas unit.

--------
 Groups
--------
There are several groups you can build:

  ./build default 
	builds the default examples with no special defines

  ./build <group> clean
	cleans the .crap/ folders of their PPU/.A/.O files
	i.e. "build default clean", "build all clean", "build gzipon clean", etc.

  ./build all 
	builds all combos (takes a while), i.e. default, plus GZIP_ON, SYSUTILS_ON

There are also some defined groups by the build author..
In powtils, some example defined groups are:

  gzipon
    enables the GZIP_ON define in all units

  gzipsysutilson
    enables both SYSUTILS_ON and GZIP_ON define in all units

  sysutilson 
    enables the SYSUTILS_ON define in all units 

These groups are just samples.. any project can contain more "groups"
We call these "groups" because "targets" is too overloaded of a term.

-------
 Flags
-------
  clean 
    cleans .ppu/.a/.o files 

  rebuild 
    cleans then builds from scratch


------
 Help
------
You can find out what GROUPS and FLAGS are available by typing in:
./build

The command line "help" will tell you what groups are available.

Note: On Windows, no need for the ./ as this is a unix thing ;-)

-------------------
 Building Build.pp
-------------------
You can 
  fpc build

To rebuild the BUILD script (actually just a program!) for your platform.. 
or use build.exe or build.elf binary if included with your download.

It is like FPMAKE kind of, but fpmake didn't serve my needs, nor did
fpcmake or gnumake.

The build utility isn't perfect yet, and nothing is! It needs more features. 
But a very good codebase in pwbuildutil right now with tons of options to 
build projects.

