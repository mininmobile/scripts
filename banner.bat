@echo off
if "%~1" neq "" (
  2>nul findstr /bric:":%~1\>" "%~f0" | findstr /bivc:":font_" >nul && (
    shift /1&goto %1
  ) || (
    >&2 echo ERROR: routine %~1 not found
  )
) else >&2 echo ERROR: missing routine

:Usage                      -- Library syntax and general info
::  ____                                              _               _
:: | __ )    __ _   _ __    _ __     ___   _ __      | |__     __ _  | |_
:: |  _ \   / _` | | '_ \  | '_ \   / _ \ | '__|     | '_ \   / _` | | __|
:: | |_) | | (_| | | | | | | | | | |  __/ | |     _  | |_) | | (_| | | |_
:: |____/   \__,_| |_| |_| |_| |_|  \___| |_|    (_) |_.__/   \__,_|  \__|
::
:: Banner.bat is a library of batch routines that enables printing messages
:: to the screen using multi-line fonts.
::
::  Syntax:
::
::    [call] [path]banner command [arguments]
::
::  For a full list of commands, use:
::
::    banner help
::
::  For detailed help on a specific command, use:
::
::    banner help command
::
call :help usage
exit /b


:Help      [Command]        -- Help for commands in this library
::
::  Displays help about Command
::
::  If Command is not specified, then lists all available commands.
::
  setlocal disableDelayedExpansion
  set file="%~f0"
  echo(
  if not "%~1"=="" goto :help.func
  for /f "tokens=* delims=:" %%A in (
    'findstr /r "^:[^:]" "%~f0"^|findstr /rvi "^:font_"^|sort'
  ) do echo(  %%A
  exit /b
  :help.func
  set beg=
  for /f "tokens=1,* delims=:" %%a in ('findstr /nric:"^:%~1\>" "%~f0"') do (
    if not defined beg set beg=%%a
  )
  if not defined beg (1>&2 echo: Function %~1 not found) & exit /b 1
  set end=
  for /f "tokens=1 delims=:" %%a in ('findstr /nrc:"^[^:]" "%~f0"') do (
    if not defined end if %beg% LSS %%a set end=%%a
  )
  for /f "tokens=1,* delims=[]:" %%a in ('findstr /n "^" "%~f0"') do (
    if %beg% leq %%a if %%a lss %end% echo: %%b
  )
exit /b


:PrintStr  Font  String     -- Print a string literal
::
::  Prints String using the specified multi-line Font.
::
::  If the font has not yet been loaded, then the font will be loaded temporarily
::  and released once the line has been printed. If printing multiple lines, then
::  it is more efficient to pre-load the font using LoadFont.
::
::  The following escape sequences are available for troublesome characters:
::
::    \c = ^ (caret)
::
::    \p = % (percent)
::
::    \q = " (quote)
::
::    \\ = \ (backslash)
::
setlocal disableDelayedExpansion
set "str=%~2"
setlocal enableDelayedExpansion
set "str=!str:\q="!"
set "str=!str:\c=^!"
set "str=!str:\p=%%!"
set "str=!str:\\=\!"
call :printVar %1 str
exit /b


:PrintVar  Font  StrVar     -- Print value of a string variable
::
::  Prints the value of variable StrVar using the specified multi-line Font.
::
::  If the font has not yet been loaded, then the font will be loaded temporarily
::  and released once the line has been printed. If printing multiple lines, then
::  it is more efficient to pre-load the font using LoadFont.
::
setlocal enableDelayedExpansion
if not defined font.%~1.height call :loadFont %1
set "lower=abcdefghijklmnopqrstuvwxyz"
call :strLen %~2 len
set /a len-=1
for /l %%N in (1 1 !font.%~1.height!) do set "ln%%N="
for /l %%P in (0 1 %len%) do (
  set "chr=!%~2:~%%P,1!"
  if "!chr!" equ "=" (
    set "chr=equal"
  ) else if "!chr!" equ ":" (
    set "chr=colon"
  ) else if "!chr!" equ "^!" (
    set "chr=bang"
  ) else if "!chr!" equ "^^" (
    set "chr=^^"
  ) else if "!chr!" neq "*" if "!chr!" neq "~" for /f "delims=" %%C in ("!chr!") do if "!lower:%%C=%%C!" neq "!lower!" set "chr=upper%%C"
  if not defined font.%~1.!chr!.1 set "chr=missing"
  for /f delims^=^ eol^= %%C in ("!chr!") do for /l %%N in (1 1 !font.%~1.height!) do set "ln%%N=!ln%%N!!font.%~1.%%C.%%N!"
)
for /l %%N in (1 1 !font.%~1.height!) do echo(!ln%%N!
exit /b


:LoadFont  Font             -- Load a font definition for later use
::
::  Loads Font into memory to enable faster printing
::
if "%~1" equ "" (
  echo ERROR: Missing font argument
  exit /b 1
)
setlocal disableDelayedExpansion
if exist "%~dp0Font_%~1.bat" (
  call "%~dp0Font_%~1.bat"
) else findstr /bri ":font_%~1\>" "%~f0" >nul && (
  call :font_%~1
) || (
  echo ERROR: Font %~1 not found
  exit /b 1
)
set font.%~1.setlocal=1
setlocal enableDelayedExpansion
set "lower=abcdefghijklmnopqrstuvwxyz"
set "font.%~1.height=!fontHeight!"
set /a "pos=0, ln=1, start=0"
for %%W in (!fontWidth!) do for %%S in (!start!) do (
  if !pos! equ 0 (
    set chr=missing
  ) else for %%N in (!pos!) do set "chr=!fontChars:~%%N,1!"
  if "!chr!" equ "^!" (
    set "chr=bang"
  ) else if "!chr!" equ "=" (
    set "chr=equal"
  ) else if "!chr!" equ ":" (
    set "chr=colon"
  ) else if "!chr!" neq "*" if "!chr!" neq "~" for /f "delims=" %%C in ("!chr!") do if "!lower:%%C=%%C!" neq "!lower!" set "chr=upper%%C"
  for /l %%N in (1 1 !fontHeight!) do set "font.%~1.!chr!.%%N=!font%%N:~%%S,%%W!"
  set /a "start+=%%W, pos+=1"
)
for /f "delims=" %%A in ('set font.%~1.') do (
  if defined font.%~1.setlocal endlocal&endlocal
  if "%%A" neq "font.%~1.setlocal=1" set "%%A"
)
exit /b


:ListFonts                  -- List all available fonts
::
::  List all available fonts. Fonts may be embedded directly within this
::  script, or they may be stand-alone files within the same directory
::  as this library.
echo(
(
  for /f "delims=_. tokens=2" %%A in (
    'findstr /lbi :font_ "%~f0"^^^&dir /b "%~dp0font_*.bat"'
  ) do @echo   %%A
)|sort


:StrLen    StrVar  LenVar   -- Compute the length of a string
::
:: Compute the length of the string within variable StrVar
:: and return the result in variable LenVar.
::
:: Many thanks to 'sowgtsoi', but also 'jeb' and 'amel27' dostips forum users
:: helped making this short and efficient.
:: Created 20081122 :$changed 20101116 :$categories StringOperation
:: Source http://www.dostips.com
(   SETLOCAL ENABLEDELAYEDEXPANSION
    set "str=A!%~1!"&rem keep the A up front to ensure we get the length and not the upper bound
                     rem it also avoids trouble in case of empty string
    set "len=0"
    for /L %%A in (12,-1,0) do (
        set /a "len|=1<<%%A"
        for %%B in (!len!) do if "!str:~%%B,1!"=="" set /a "len&=~1<<%%A"
    )
)
( ENDLOCAL & REM RETURN VALUES
    IF "%~2" NEQ "" SET /a %~2=%len%
)
EXIT /b


:: Font Definitions
:: ================================================================================
:: Additional fonts may be appended to this script with a label of :font_fontName
:: Alternatively, a font may be installed as a stand-alone file in the same folder
:: as banner.bat. Each font file should be named font_fontName.bat
::
:: Each font should define fontChars, fontHeight, fontWidth, and font1...fontN. The
:: letters in fontChars should correspond to the letters defined in font1..fontN.
:: You can define as many or as few characters as you want for a given font.
:: A special symbol will be used in place of any undefined character. The first
:: character must be the symbol used to represent an undefined character.
:: If " is defined, then it should be the last character.
:: Don't forget to double the % in the fontChars string.

:Font_Big
set "fontChars= ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz0123456789`~!@#$%%^&*()_+-={}|[]\:;'<>?,./""
set "fontHeight=8"
set "fontWidth=   6       11       8        9        9        9        9         9       9        8        9      7       9        9        8        9        9        9        9        9       10         9        11           15          8       10        8      6      8       8       7       8      7    6       8       8     4    6      7    4      12         8       8      8         8     7      6     6      8       8        11       7       8      6      8      5    7       8       9        8       8       9        8       8     4    6    4      10        11       6      8     5      9         10      5   5       9       8       9        9       6     6    4    6     6      8     4   4   4     6    6     7     4   4     8      6  "
set     "font1=                   ____     _____   _____    ______   ______    _____   _    _   _____        _   _  __  _        __  __   _   _    ____    _____     ____    _____     _____   _______   _    _  __      __ __          __ __   __ __     __  ______                _                  _           __           _       _     _   _      _                                                            _                                                      ___    __   ___    ____    _  _     _____     __    ______    ___     ___    _   /\/|  _     ____      _  _      _    _   __  /\               _       __ __                                         __ __     _   ___   ___  __               _     __ __     ___                __  _ _ "
set     "font2= .....     /\     |  _ \   / ____| |  __ \  |  ____| |  ____|  / ____| | |  | | |_   _|      | | | |/ / | |      |  \/  | | \ | |  / __ \  |  __ \   / __ \  |  __ \   / ____) |__   __| | |  | | \ \    / / \ \        / / \ \ / / \ \   / / |___  /               | |                | |         / _|         | |     (_)   (_) | |    | |                                                          | |                                                    / _ \  /_ | |__ \  |___ \  | || |   | ____|   / /   |____  |  / _ \   / _ \  ( ) |/\/  | |   / __ \   _| || |_   | |  (_) / / |/\|   ___     /\| |/\   / / \ \              _              ______    / / \ \   | | |  _| |_  | \ \      _   _  ( )   / / \ \   |__ \              / / ( | )"
set     "font3= .....    /  \    | |_) | | |      | |  | | | |__    | |__    | |  __  | |__| |   | |        | | | ' /  | |      | \  / | |  \| | | |  | | | |__) | | |  | | | |__) | | (___      | |    | |  | |  \ \  / /   \ \  /\  / /   \ V /   \ \_/ /     / /          __ _  | |__     ___    __| |   ___  | |_    __ _  | |__    _     _  | | __ | |  _ __ ___    _ __     ___    _ __     __ _   _ __   ___  | |_   _   _  __   __ __      __ __  __  _   _   ____ | | | |  | |    ) |   __) | | || |_  | |__    / /_       / /  | (_) | | (_) |  \|       | |  / / _` | |_  __  _| / __)    / /        ( - )    \ ` ' /  | |   | |           _| |_   ______  |______|  | |   | |  | | | |     | |  \ \    (_) (_) |/   / /   \ \     ) |            / /   V V "
set     "font4= .....   / /\ \   |  _ <  | |      | |  | | |  __|   |  __|   | | |_ | |  __  |   | |    _   | | |  <   | |      | |\/| | | . ` | | |  | | |  ___/  | |  | | |  _  /   \___ \     | |    | |  | |   \ \/ /     \ \/  \/ /     > <     \   /     / /          / _` | | '_ \   / __|  / _` |  / _ \ |  _|  / _` | | '_ \  | |   | | | |/ / | | | '_ ` _ \  | '_ \   / _ \  | '_ \   / _` | | '__| / __| | __| | | | | \ \ / / \ \ /\ / / \ \/ / | | | | |_  / | | | |  | |   / /   |__ <  |__   _| |___ \  | '_ \     / /    > _ <   \__, |           | | | | (_| |  _| || |_  \__ \   / /         / _ \/\ |_     _| | |   | |          |_   _| |______|  ______  / /     \ \ | | | |     | |   \ \               < <     > >   / /            / /        "
set     "font5= .....  / ____ \  | |_) | | |____  | |__| | | |____  | |      | |__| | | |  | |  _| |_  | |__| | | . \  | |____  | |  | | | |\  | | |__| | | |      | |__| | | | \ \   ____) |    | |    | |__| |    \  /       \  /\  /     / . \     | |     / /__        | (_| | | |_) | | (__  | (_| | |  __/ | |   | (_| | | | | | | |   | | |   <  | | | | | | | | | | | | | (_) | | |_) | | (_| | | |    \__ \ | |_  | |_| |  \ V /   \ V  V /   >  <  | |_| |  / /  | |_| |  | |  / /_   ___) |    | |    ___) | | (_) |   / /    | (_) |    / /            |_|  \ \__,_| |_  __  _| (   /  / / _       | (_>  <  / , . \  | |   | |            |_|            |______| \ \     / / | | | |     | |    \ \   _   _       \ \   / /   |_|    _   _   / /         "
set     "font6=       /_/    \_\ |____/   \_____| |_____/  |______| |_|       \_____| |_|  |_| |_____|  \____/  |_|\_\ |______| |_|  |_| |_| \_|  \____/  |_|       \___\_\ |_|  \_\ (_____/     |_|     \____/      \/         \/  \/     /_/ \_\    |_|    /_____|        \__,_| |_.__/   \___|  \__,_|  \___| |_|    \__, | |_| |_| |_|   | | |_|\_\ |_| |_| |_| |_| |_| |_|  \___/  | .__/   \__, | |_|    |___/  \__|  \__,_|   \_/     \_/\_/   /_/\_\  \__, | /___|  \___/   |_| |____| |____/     |_|   |____/   \___/   /_/      \___/    /_/             (_)   \____/    |_||_|    |_|  /_/ (_)       \___/\/  \/|_|\/  | |   | |                                     | |   | |  | | | |_   _| |     \_\ (_) ( )       \_\ /_/    (_)   ( ) (_) /_/          "
set     "font7=                                                                                                                                                                                                                                                                                                          __/ |              _/ |                                        | |         | |                                                        __/ |                                                                                                                                                               \_\ /_/   ______                              \_\ /_/   |_| |___| |___|             |/                         |/                   "
set     "font8=                                                                                                                                                                                                                                                                                                         |___/              |__/                                         |_|         |_|                                                       |___/                                                                                                                                                                         |______|                                                                                                                   "
exit /b

:Font_Standard
set "fontChars= ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz0123456789`~!@#$%%^&*()_+-={}|[]\:;'<>?,./""
set "fontHeight=6"
set "fontWidth=   6      10       8        8       8       8       8       8       8      6      8      7       8       9        8       8       8       8       8       8       8       8       10          13        7       8      7     4     8      8       7        8      7     6      8       8     4    6      7    4      12         8       8       8       8      7      6     6      8       8        11       7       8      6      8     4     8       8       9        8       8       8       8       8     4    6    4      10        11       6     7     5      9       7      5   5      8       8       8       8      6     6    4   5     5     7    4   4   4    5   5     6    4   4    7      6  "
set     "font1=           _      ____     ____   ____    _____   _____    ____   _   _   ___       _   _  __  _       __  __   _   _    ___    ____     ___    ____    ____    _____   _   _  __     __ __        __ __  __ __   __  _____              _                  _           __           _       _     _   _      _                                                            _                                                      ___    _   ____    _____   _  _     ____     __     _____    ___     ___    _   /\/|  _     ____      _  _      _    _  __  /\    ___             __ __                                      __ __     _   __   __  __              _    __ __    ___              __  _ _ "
set     "font2= .....    / \    | __ )   / ___| |  _ \  | ____| |  ___|  / ___| | | | | |_ _|     | | | |/ / | |     |  \/  | | \ | |  / _ \  |  _ \   / _ \  |  _ \  / ___|  |_   _| | | | | \ \   / / \ \      / / \ \/ / \ \ / / |__  /       __ _  | |__     ___    __| |   ___   / _|   __ _  | |__   (_)   (_) | | __ | |  _ __ ___    _ __     ___    _ __     __ _   _ __   ___  | |_   _   _  __   __ __      __ __  __  _   _   ____  / _ \  / | |___ \  |___ /  | || |   | ___|   / /_   |___  |  ( _ )   / _ \  ( ) |/\/  | |   / __ \   _| || |_   | |  (_)/ / |/\|  ( _ )   __/\__  / / \ \             _             _____    / / \ \   | | | _| |_ | \ \     _   _  ( )  / / \ \  |__ \            / / ( | )"
set     "font3= .....   / _ \   |  _ \  | |     | | | | |  _|   | |_    | |  _  | |_| |  | |   _  | | | ' /  | |     | |\/| | |  \| | | | | | | |_) | | | | | | |_) | \___ \    | |   | | | |  \ \ / /   \ \ /\ / /   \  /   \ V /    / /       / _` | | '_ \   / __|  / _` |  / _ \ | |_   / _` | | '_ \  | |   | | | |/ / | | | '_ ` _ \  | '_ \   / _ \  | '_ \   / _` | | '__| / __| | __| | | | | \ \ / / \ \ /\ / / \ \/ / | | | | |_  / | | | | | |   __) |   |_ \  | || |_  |___ \  | '_ \     / /   / _ \  | (_) |  \|       | |  / / _` | |_  ..  _| / __)   / /        / _ \/\ \    / | |   | |          _| |_   _____  |_____|  | |   | |  | | | |   | |  \ \   (_) (_) |/  / /   \ \   / /           / /   V V "
set     "font4= .....  / ___ \  | |_) | | |___  | |_| | | |___  |  _|   | |_| | |  _  |  | |  | |_| | | . \  | |___  | |  | | | |\  | | |_| | |  __/  | |_| | |  _ <   ___) |   | |   | |_| |   \ V /     \ V  V /    /  \    | |    / /_      | (_| | | |_) | | (__  | (_| | |  __/ |  _| | (_| | | | | | | |   | | |   <  | | | | | | | | | | | | | (_) | | |_) | | (_| | | |    \__ \ | |_  | |_| |  \ V /   \ V  V /   >  <  | |_| |  / /  | |_| | | |  / __/   ___) | |__   _|  ___) | | (_) |   / /   | (_) |  \__, |           |_| | | (_| | |_      _| \__ \  / /_       | (_>  < /_  _\ | |   | |         |_   _| |_____| |_____| < <     > > | | | |   | |   \ \   _   _      \ \   / /  |_|   _   _   / /        "
set     "font5= ..... /_/   \_\ |____/   \____| |____/  |_____| |_|      \____| |_| |_| |___|  \___/  |_|\_\ |_____| |_|  |_| |_| \_|  \___/  |_|      \__\_\ |_| \_\ |____/    |_|    \___/     \_/       \_/\_/    /_/\_\   |_|   /____|      \__,_| |_.__/   \___|  \__,_|  \___| |_|    \__, | |_| |_| |_|  _/ | |_|\_\ |_| |_| |_| |_| |_| |_|  \___/  | .__/   \__, | |_|    |___/  \__|  \__,_|   \_/     \_/\_/   /_/\_\  \__, | /___|  \___/  |_| |_____| |____/     |_|   |____/   \___/   /_/     \___/     /_/            (_)  \ \__,_|   |_||_|   (   / /_/(_)       \___/\/   \/   | |   | |  _____    |_|                    | |   | |  | | | |   | |    \_\ (_) ( )      \_\ /_/   (_)  ( ) (_) /_/         "
set     "font6=                                                                                                                                                                                                                                                                             |___/              |__/                                         |_|         |_|                                                       |___/                                                                                                     \____/              |_|                               \_\ /_/  |_____|                           \_\ /_/   |_| |__| |__|            |/                      |/                  "
exit /b