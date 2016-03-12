INCLUDE_PATH = 
SHELL = /bin/sh
CC = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/mingw/bin/gcc"
CPP = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/mingw/bin/gcc"
CFLAGS = -O0 -pipe -imacros eif_config.mingw.h -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -D_UNICODE -DUNICODE   -DEIF_IEEE_BEHAVIOR -DWORKBENCH -I"G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/studio/spec/win64/include" -I. $(INCLUDE_PATH)
CPPFLAGS = -O0 -pipe -imacros eif_config.mingw.h -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -D_UNICODE -DUNICODE   -DWORKBENCH -I"G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/studio/spec/win64/include" -I. $(INCLUDE_PATH)
LDFLAGS = 
CCLDFLAGS =   -mconsole
LDSHAREDFLAGS =  
EIFLIB = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/studio/spec/win64/lib/mingw/wkbench.a"
EIFTEMPLATES = G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/studio/config/win64/templates
LIBS = 
MAKE = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/msys/1.0/bin/make.exe"
AR = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/mingw/bin/ar"
LD = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/mingw/bin/ld"
MKDEP =   --
MV = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/msys/1.0/bin/cp"
CP = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/msys/1.0/bin/cp"
RANLIB = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/mingw/bin/ranlib.exe"
RM = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/msys/1.0/bin/rm" -f
FILE_EXIST = 
RMDIR = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/msys/1.0/bin/rd"
X2C = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/studio/spec/win64/bin/x2c.exe"
SHAREDLINK = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/mingw/bin/dllwrap"
SHAREDLIBS = -luser32 -lws2_32 -ladvapi32 -lgdi32 -lshell32 -lmsimg32 -lcomdlg32 -luuid -lole32 -loleaut32 -lcomctl32 -lmpr -lshlwapi -lwinspool -lstdc++ 
SHARED_SUFFIX = .dll
COMMAND_MAKEFILE = 
START_TEST = if [ ! -f finished ] ; then 
END_TEST = ; fi 
CREATE_TEST = "G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/msys/1.0/bin/touch" finished
PATH := G:\Program Files\Eiffel Software\EiffelStudio 15.12 GPL/gcc/win64/mingw/libexec/gcc/mingw32/3.4.2;G:\Python27\;G:\Python27\Scripts;C:\ProgramData\Oracle\Java\javapath;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files (x86)\Skype\Phone\;G:\Program Files\Git\cmd;C:\Program Files\Java\jdk1.8.0_74\bin;G:\apache-maven-3.3.9-bin\apache-maven-3.3.9\bin;G:\apache-ant-1.9.6\bin 
SYSTEM_IN_DYNAMIC_LIB = simulation.dll 

.SUFFIXES:.cpp .o 

.c.o:
	$(CC) $(CFLAGS) -c $<

.cpp.o:
	$(CPP) $(CPPFLAGS) -c $<

OBJECTS = big_file_C1_c.o 

OLDOBJECTS =  ap862.o ap862d.o el861.o el861d.o th865.o th865d.o mu866.o mu866d.o \
	th867.o th867d.o th864.o th864d.o th863.o th863d.o 

all::  Cobj1.o

Cobj1.o: $(OBJECTS) Makefile
	$(RM) $@
	$(LD) -r -o $@ $(OBJECTS)
	$(CREATE_TEST)
	$(RM) $(OBJECTS)


clean: local_clean
clobber: local_clobber

local_clean::
	$(RM) core finished *.o

local_clobber:: local_clean
	$(RM) Makefile

