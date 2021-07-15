@echo off
setlocal EnableDelayedExpansion

set RawAccelDir=%~dp0

rem Handle optional parameters on the left of profile name
if "%~1" == "--list" (
  call :list_profiles %~2
  exit /b !errorlevel!
)
if "%~1" == "--save" (
  call :save_profile %~2
  exit /b !errorlevel!
)
if "%~1" == "--delete" (
  call :delete_profile %~2
  exit /b !errorlevel!
)

rem Handle --gui and --writer parameters on the left of profile name
rem by simply calling :restore_profile with the parameters in the
rem reverse order. Unfortunately, we still need an early check that a
rem profile name is specified, or else :restore_profile will think the
rem optional parameter itself is the profile name.
if "%~1" == "--gui" (
  call :check_profile 1 %~2
  if !errorlevel! neq 0 exit /b !errorlevel!

  call :restore_profile %~2 %~1
  exit /b
)
if "%~1" == "--writer" (
  call :check_profile 1 %~2
  if !errorlevel! neq 0 exit /b !errorlevel!

  call :restore_profile %~2 %~1
  exit /b !errorlevel!
)

rem Handle optional parameters on the right of profile name
if "%~2" == "--list" (
  call :list_profiles %~1
  exit /b !errorlevel!
)
if "%~2" == "--save" (
  call :save_profile %~1
  exit /b !errorlevel!
)
if "%~2" == "--delete" (
  call :delete_profile %~1
  exit /b !errorlevel!
)

rem The :restore_profile function already expects the --gui and
rem --writer parameters to be on the right of the profile name.
call :restore_profile %~1 %~2
exit /b !errorlevel!

:restore_profile
  call :check_profile 0 %1
  if !errorlevel! neq 0 exit /b !errorlevel!

  call :kill_rawaccelGUI
  if !errorlevel! neq 0 exit /b !errorlevel!

  copy "%~dp0profiles\%1.json" "%RawAccelDir%\settings.json" > nul
  if !errorlevel! neq 0 exit /b 10

  if "%2" == "--gui" (
    call :start_GUI
  ) else (
    if "%2" == "--writer" (
      call :start_writer
    ) else (
      if defined _restartGUI (
        call :start_GUI
      ) else (
        call :start_writer
      )
    )
  )
  exit /b !errorlevel!
rem :restore_profile

:kill_rawaccelGUI
  taskkill /IM rawaccel.exe > nul 2>&1
  if !errorlevel! equ 0 (
    set "_restartGUI=1"
  ) else (
    if !errorlevel! neq 128 exit /b 1000
  )
  exit /b 0
rem :kill_rawaccelGUI

:start_GUI
  start "" /D "%RawAccelDir%" /MAX "%RawAccelDir%\rawaccel.exe"
  if !errorlevel! equ 9059 exit /b 2000
  exit /b 0
rem :start_GUI

:start_writer
  start "" /D "%RawAccelDir%" "%RawAccelDir%\writer.exe" "settings.json"
  if !errorlevel! equ 9059 exit /b 2000
  exit /b 0
rem :start_writer

:list_profiles
  if [%1] equ [] (
    set "fn=*"
  ) else (
    set "fn=%1"
  )

  for /f %%a in ('dir %~dp0profiles\%fn%.json /a-d /b 2^> nul') do echo %%~na
  exit /b 0
rem :list_profiles

:save_profile
  call :check_profile 1 %1
  if !errorlevel! neq 0 exit /b !errorlevel!

  if not exist "%RawAccelDir%\settings.json" (
    echo Could not find a RawAccel settings.json file to save from.
    exit /b 5
  )

  rem No need to check !errorlevel! on mkdir, as all
  rem possible values are valid for our purposes.
  rem We do not care if the directory already exists.
  mkdir "%~dp0profiles" 2> nul

  copy "%RawAccelDir%\settings.json" "%~dp0profiles\%1.json" > nul
  if !errorlevel! neq 0 exit /b 10
  echo Current RawAccel settings saved as %1.

  exit /b 0
rem :save_profile

:delete_profile
  call :check_profile 0 %1
  if !errorlevel! neq 0 exit /b !errorlevel!

  rem No need to check !errorlevel! on del as it will always be 0.
  del "%~dp0profiles\%1.json" > nul
  echo The %1 profile was deleted.

  exit /b 0
rem :delete_profile

:check_profile
  if [%2] equ [] (
    echo No profile specified.
    exit /b 1
  )

  if %1 equ 0 (
    if not exist "%~dp0profiles\%2.json" (
      echo No profile exists with the name %2.
      exit /b 2
    )
  )

  exit /b 0
rem :check_profile
