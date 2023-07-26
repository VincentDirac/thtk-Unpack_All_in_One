@echo off
thdat -x d ./th19/th19.dat -C ./data
pause
for /r %%c in (*.anm) do thanm -x 19 "%%c"
pause
for /r %%c in (pl*.msg) do thmsg -d 19 "%%c" ./dialogue/"%%~nc".txt
pause
for /r %%c in (e*.msg) do thmsg -e -d 19 "%%c" ./dialogue/"%%~nc".txt
pause
for /r %%c in (pl*.ecl) do thecl -d 19 -rxj "%%c" ./spellcard/"%%~nc".txt
pause
python thbgm.py -f ./data/thbgm.fmt -d ./th19/thbgm.dat -lWI -L 2
pause
python shift_jis_to_utf-8.py
pause
python transBFA.py
pause