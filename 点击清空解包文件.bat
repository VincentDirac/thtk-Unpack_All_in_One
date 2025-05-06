@echo off
set /p response=Are you sure you want to empty all unpacked files? [Y/n]:

if /i "%response%"=="" goto execute
if /i "%response%"=="n" goto skip
if /i "%response%"=="y" goto execute
if /i "%response%"=="Y" goto execute

:skip
echo Skipping...
goto end

:execute
for %%d in (anm bgm data dialogue ecl msg) do (
    if exist "%%d" (
        pushd "%%d"
        :: 删除所有非 .gitignore 的文件
        for /f "delims=" %%f in ('dir /b /s /a-d ^| findstr /v /i ".gitignore"') do (
            del /q "%%f"
        )
        :: 删除空的子目录
        for /f "delims=" %%d in ('dir /b /s /ad') do (
            rd /s /q "%%d" 2>nul
        )
        popd
    )
)
echo Done.

:end
pause