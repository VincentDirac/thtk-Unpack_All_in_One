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

:: 初始化变量
set "THVER="
set "IS_TRIAL=0"

:: 遍历文件夹中的文件
for %%F in ("%THDIR%\*") do (
    set "filename=%%~nxF"
    
    :: 查找形如 thNN.exe 的文件，提取版本号
    echo !filename! | findstr /r /i "^th[0-9][0-9]" >nul
    if !errorlevel! == 0 (
        set "namepart=!filename:~2,2!"
        set "THVER=!namepart!"
    )

    :: 检查文件名是否包含 tr，标记为体验版
    echo !filename! | find /i "tr" >nul && set "IS_TRIAL=1"
)

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
for /r "%WORKSPACE%" %%c in (pl*.ecl) do "%THTK_ECL%" -d %THVER% "%%c" -rxj ./ecl/"%%~nc".txt
for /r "%WORKSPACE%" %%c in (st*.ecl) do "%THTK_ECL%" -d %THVER% "%%c" -rxj ./ecl/"%%~nc".txt

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
for %%F in (*.wav) do (
    ffmpeg -i "%%F" -c:a libmp3lame -b:a 320k "%%~nF.mp3"
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
pause
