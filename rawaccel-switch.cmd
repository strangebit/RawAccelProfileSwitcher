@echo off

set RawAccelDir=%~dp0

if "%~1" == "--save" goto reverse_params
if "%~1" == "--delete" goto reverse_params
if "%~1" == "--gui" goto reverse_params
if "%~1" == "--writer" goto reverse_params

if "%~1" == "--list" (
  call :list_profiles %~2
  goto :eof
)

call :begin %~1 %~2
goto :eof

:reverse_params
if "%~2" == "" (
  call :no_profile
  goto :eof
) else (
  call :begin %~2 %~1
  goto :eof
)

:begin
if "%1" == "" (
  call :no_profile
  goto :eof
)
if "%2" == "--list" (
  call :list_profiles %1
  goto :eof
)
if "%2" == "--save" (
  call :save_profile %1
  goto :eof
)
if not exist "%~dp0profiles\%1.json" (
  call :invalid_profile
  goto :eof
)
if "%2" == "--delete" (
  call :delete_profile %1
  goto :eof
)

call :kill_rawaccelGUI
copy "%~dp0profiles\%1.json" "%RawAccelDir%\settings.json" > nul

if "%2" == "--gui" (
  call :start_GUI
) else (
  if "%2" == "--writer" (
    call :start_writer
  ) else (
    if defined restartGUI (
      call :start_GUI
    ) else (
      call :start_writer
    )
  )
)
goto :eof

:kill_rawaccelGUI
taskkill /IM rawaccel.exe > nul 2>&1
if not errorlevel 128 (set restartGUI=1)
goto :eof

:start_GUI
start "" /D "%RawAccelDir%" /MAX "%RawAccelDir%\rawaccel.exe"
goto :eof

:start_writer
start "" /D "%RawAccelDir%" "%RawAccelDir%\writer.exe" "settings.json"
goto :eof

:no_profile
echo No profile specified.
goto :eof

:invalid_profile
echo No such profile exists.
goto :eof

:list_profiles
if "%1" == "" (set fn=*) else (set fn=%1)
for /f %%a in ('dir %~dp0profiles\%fn%.json /b 2^> nul') do echo %%~na
goto :eof

:save_profile
if not exist "%RawAccelDir%\settings.json" (
  echo Could not find a RawAccel 'settings.json' file to save.
) else (
  mkdir "%~dp0profiles" 2> nul
  copy "%RawAccelDir%\settings.json" "%~dp0profiles\%1.json" > nul
  echo Current RawAccel settings saved as '%1'.
)
goto :eof

:delete_profile
del "%~dp0profiles\%1.json" > nul
echo The '%1' profile was deleted.
goto :eof
