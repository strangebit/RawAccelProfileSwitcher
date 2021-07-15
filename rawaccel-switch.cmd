@echo off

set RawAccelDir=%~dp0

if "%~2"=="--save" (
  goto save_profile
  goto :eof
)

if "%~1"=="" goto no_profile
if not exist "%~dp0profiles\%~1.json" goto invalid_profile
call :kill_rawaccelGUI

copy "%~dp0profiles\%~1.json" "%RawAccelDir%\settings.json" > nul

if "%~2"=="--gui" (
  call :start_GUI
) else (
  if "%~2"=="--writer" (
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
echo Invalid profile specified.
goto :eof

:save_profile
if not exist "%RawAccelDir%\settings.json" (
  echo Could not find a RawAccel 'settings.json' file to save as a profile.
) else (
  mkdir "%~dp0profiles" 2> nul
  copy "%RawAccelDir%\settings.json" "%~dp0profiles\%~1.json" > nul
  echo Current RawAccel settings saved as '%~1'.
)
goto :eof
