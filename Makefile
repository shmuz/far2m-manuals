# Example:
#   make lf SHOW=1 ARTICLE_ID=10

HH_COMPILER = hhc.exe
HH_VIEWER = hh.exe
HH_DIR = C:\Program Files (x86)\HTML Help Workshop
PATH := $(HH_DIR);$(PATH)

# Lua parameters
LUA_INIT  =
LUA_PATH  = ./?.lua;./?/init.lua
LUA_CPATH = ./?.dll

# Script parameters
LUA      = set LUA_PATH=$(LUA_PATH) && set LUA_CPATH=$(LUA_CPATH) && lua
SCRIPT   = tp2hh_new.lua
TSILIB   = tsi4
LANG     = "0x809 English (British)"
TEMPL    = templates\api.tem
CODEPAGE = 1252

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
	-$(HH_COMPILER) $(HHP)
ifdef SHOW
	$(ComSpec) /C start $(HH_VIEWER) $(CHM)$(SUFFIX)
endif

$(HHP): $(FILE_SRC)
	@if not exist $(DIR_OUT) mkdir $(DIR_OUT)
	$(LUA) $(SCRIPT) $(FILE_SRC) $(TSILIB) $(LANG) $(TEMPL) $(CODEPAGE) $(DIR_OUT)

clean:
	@if exist out rmdir /s /q out

.PHONY: lf lm l4 clean
