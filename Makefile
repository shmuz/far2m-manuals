# Example:
#   make lf SHOW=1 ARTICLE_ID=10

APPDIR= C:\Program Files (x86)\HTML Help Workshop
PATH := $(APPDIR);$(PATH)
LUA_INIT  =
LUA_PATH  = ./?.lua;./?/init.lua
LUA_CPATH = ./?.dll
TP2HH     = tp2hh_new.lua

# LuaFAR manual
lf: FILE_SRC = src\luafar2m_manual.tsi

# LuaMacro manual
lm: FILE_SRC = src\macroapi_manual_linux.tsi

# LF4Ed manual
l4: FILE_SRC = src\lf4ed_manual.tsi

name = $(basename $(notdir $(FILE_SRC)))
DIR_OUT = out\$(name)
CHM = $(DIR_OUT)\$(name).chm
HHP = $(DIR_OUT)\$(name).hhp

ifdef ARTICLE_ID
  SUFFIX = ::$(ARTICLE_ID).html
endif

lf lm l4: $(CHM)

$(CHM): $(HHP)
	-hhc.exe $(HHP)
ifdef SHOW
	$(ComSpec) /C start hh.exe $(CHM)$(SUFFIX)
endif

$(HHP): $(FILE_SRC)
	@if not exist $(DIR_OUT) mkdir $(DIR_OUT)
	set LUA_PATH=$(LUA_PATH) && set LUA_CPATH=$(LUA_CPATH) && lua $(TP2HH) $(FILE_SRC) templates\api.tem $(DIR_OUT)

clean:
	@if exist out rmdir /s /q out

.PHONY: lf lm l4 clean
