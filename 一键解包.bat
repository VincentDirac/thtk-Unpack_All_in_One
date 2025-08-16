@echo off
setlocal EnableDelayedExpansion
SET TOOLSDIR=%~dp0
SET THDIR=%1
SET WORKSPACE=%TOOLSDIR%/data

if not exist %WORKSPACE% (
    mkdir %WORKSPACE%
)

SET THTK_ANM=%TOOLSDIR%thtk\thanm
SET THTK_DAT=%TOOLSDIR%thtk\thdat
SET THTK_MSG=%TOOLSDIR%thtk\thmsg
SET THTK_ECL=%TOOLSDIR%thtk\thecl
SET THTK_ECL=%TOOLSDIR%thtk\thecl

:: 自动识别thXX.exe、thXXX.exe、thXXtr.exe、thXXXtr.exe
set "THVER="
set "IS_TRIAL=0"

setlocal enabledelayedexpansion
for %%F in ("%THDIR%\th*.exe") do (
    set "filename=%%~nxF"
    set "core=!filename:~2!"
    set "core=!core:.exe=!"

    if /i "!core:~-2!"=="tr" (
        set "IS_TRIAL=1"
        set "verpart=!core:~0,-2!"
    ) else (
        set "IS_TRIAL=0"
        set "verpart=!core!"
    )

    REM 判断verpart长度为2或3且全为数字
    set "vlen=0"
    for %%C in (!verpart!) do set /a vlen+=1
    set "isnum=1"
    for /f "delims=0123456789" %%C in ("!verpart!") do set "isnum=0"
    if "!isnum!"=="1" (
        if "!verpart:~2!"=="" (
            call set "THVER=!verpart!"
            call set "IS_TRIAL=!IS_TRIAL!"
            goto found
        )
        if "!verpart:~3!"=="" (
            call set "THVER=!verpart!"
            call set "IS_TRIAL=!IS_TRIAL!"
            goto found
        )
    )
)
endlocal
:found

SET DAT=th%THVER%.dat
SET BGMDAT=thbgm.dat
SET BGMFMT=thbgm.fmt
SET MUSICCMT=musiccmt.txt

cd %TOOLSDIR%

echo GameInfo
echo Ver: %THVER%
echo Dir: %THDIR%
if "%IS_TRIAL%"=="1" (
    echo Currently tiral version.
    SET DAT=th%THVER%tr.dat
    SET BGMDAT=thbgm_tr.dat
    SET BGMFMT=thbgm_tr.fmt
    SET MUSICCMT=musiccmt_tr.txt
) else (
    echo Currently formal version.
)
pause

:: 解包 DAT 文件
set /p response=Do you want to unpack the dat file? [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
echo Unpack DAT...
"%THTK_DAT%" -x %THVER% "%THDIR%/%DAT%" -C "%WORKSPACE%"

:end
pause

:: 解包 ANM 文件
set /p response=Do you want to unpack the anm file? [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
echo Unpack ANM...
if not exist ./anm (
    mkdir ./anm
)
cd ./anm
for /r "%WORKSPACE%" %%c in (*.anm) do "%THTK_ANM%" -x %THVER% "%%c" -ouuv
for /r "%WORKSPACE%" %%c in (*.anm) do "%THTK_ANM%" -l %THVER% -ouv -m anmmap "%%c" >>anm.txt
cd ..

:end
pause

:: 解包 MSG 文件
set /p response=Do you want to unpack the msg file? [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
echo Unpack MSG...
if not exist ./msg (
    mkdir ./msg
)
for /r "%WORKSPACE%" %%c in (pl*.msg) do "%THTK_MSG%" -d %THVER% "%%c" ./msg/"%%~nc".txt
for /r "%WORKSPACE%" %%c in (st*.msg) do "%THTK_MSG%" -d %THVER% "%%c" ./msg/"%%~nc".txt
for /r "%WORKSPACE%" %%c in (msg*.msg) do "%THTK_MSG%" -d %THVER% "%%c" ./msg/"%%~nc".txt
for /r "%WORKSPACE%" %%c in (msg*.dat) do "%THTK_MSG%" -d %THVER% "%%c" ./msg/"%%~nc".txt
pause

echo Unpack END MSG...
for /r "%WORKSPACE%" %%c in (e*.msg) do "%THTK_MSG%" -e -d %THVER% "%%c" ./msg/"%%~nc".txt

:end
pause


set /p response=Do you want to unpack the ecl file? [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
echo Unpack ECL...
if not exist ./ecl (
    mkdir ./ecl
)
for /r "%WORKSPACE%" %%c in (*.ecl) do "%THTK_ECL%" -d %THVER% "%%c" -rxj ./ecl/"%%~nc".txt

:end
pause

:: 转换编码为 UTF-8
echo Convert Encoding to UTF8...
python "%TOOLSDIR%shift_jis_to_utf-8.py"
pause

:: 解包 BGM 文件并生成 BgmForAll 文件
set /p response=Do you want to unpack the BGM file and generate BgmForAll files? [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
echo Unpack BGM...
if not exist ./bgm (
    mkdir ./bgm
)
cd ./bgm
python "%TOOLSDIR%thbgm.py" -f "%WORKSPACE%/%BGMFMT%" -d "%THDIR%/%BGMDAT%" -lWI -L 2
cd ..
pause

echo Get BgmForAll Info...
python "%TOOLSDIR%transBFA.py" -c "%TOOLSDIR%/data/%MUSICCMT%" -d "%TOOLSDIR%/bgm/"
echo Done.

:end
pause

:: 转换 BGM 文件为 MP3 格式
set /p response=Do you want to Convert BGM to MP3 files? Please make sure ffmpeg is installed and in PATH. [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
echo Convert BGM to MP3...
cd ./bgm
if not exist mp3 (
    mkdir mp3
)
for %%F in (*.wav) do (
    ffmpeg -i "%%F" -c:a libmp3lame -b:a 320k "mp3/%%~nF.mp3"
)
cd ..

:end
pause

:: 生成对话wikitext
set /p response=Do you want to generate dialogue wikitext? [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
echo Generate dialogue wikitext...
python "%TOOLSDIR%transDialogue.py" --thver %THVER%
:end
echo All done.
pause
