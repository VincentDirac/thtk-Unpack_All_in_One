@echo off
SET TOOLSDIR=%~dp0
SET THDIR=%1
SET WORKSPACE=%TOOLSDIR%/data

SET THTK_ANM=%TOOLSDIR%thtk\thanm
SET THTK_DAT=%TOOLSDIR%thtk\thdat
SET THTK_MSG=%TOOLSDIR%thtk\thmsg
SET THTK_ECL=%TOOLSDIR%thtk\thecl
SET THTK_ECL=%TOOLSDIR%thtk\thecl

SET THVER=19
SET DAT=th19tr.dat
SET BGMFMT=thbgm_tr.fmt
SET MUSICCMT=musiccmt_tr.txt

cd %TOOLSDIR%

echo GameInfo
echo Ver: %THVER%
echo Dir: %THDIR%
pause

echo Unpack Dat...
"%THTK_DAT%" -x d "%THDIR%/%DAT%" -C "%WORKSPACE%"
pause

echo Unpack ANM...
cd ./anm
for /r "%WORKSPACE%" %%c in (*.anm) do "%THTK_ANM%" -x %THVER% "%%c"
cd ..
pause

echo Unpack MSG...
for /r "%WORKSPACE%" %%c in (pl*.msg) do "%THTK_MSG%" -d %THVER% "%%c" ./dialogue/"%%~nc".txt
pause

echo Unpack END MSG...
for /r "%WORKSPACE%" %%c in (e*.msg) do "%THTK_MSG%" -e -d %THVER% "%%c" ./dialogue/"%%~nc".txt
pause

echo Unpack END ECL...
for /r "%WORKSPACE%" %%c in (pl*.ecl) do "%THTK_ECL%" -d %THVER% -rxj "%%c" ./spellcard/"%%~nc".txt
pause

echo Unpack BGM...
cd ./bgm
python "%TOOLSDIR%thbgm.py" -f "%WORKSPACE%/%BGMFMT%" -d "%THDIR%/%DAT%" -lWI -L 2
cd ..
pause

echo Convert Encoding to UTF8...
python "%TOOLSDIR%shift_jis_to_utf-8.py"
pause

echo Get BgmForAll Info...
python "%TOOLSDIR%transBFA.py" -c "%TOOLSDIR%/data/%MUSICCMT%" -d "%TOOLSDIR%/bgm/"
echo Done.
pause