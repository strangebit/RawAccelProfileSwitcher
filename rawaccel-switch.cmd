@echo off
setlocal EnableDelayedExpansion

set RawAccelDir=%~dp0

if "%~1" == "--help" (
  call :display_help
  exit /b !errorlevel!
)

rem Handle options to the left of the profile name
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

rem Handle --gui and --writer options to the left of the profile name
rem by simply calling :restore_profile and passing its parameters in the
rem reverse order. Unfortunately, we still need an early check that the
rem profile name is specified, because otherwise :restore_profile will
rem think the option itself is the profile name.
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

rem Handle options to the right of the profile name
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
rem --writer options to be to the right of the profile name.
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
    if defined _restartGUI (
      timeout /t 1 /nobreak > nul
    )
    call :start_GUI
  ) else (
    if "%2" == "--writer" (
      call :start_writer
    ) else (
      if defined _restartGUI (
        timeout /t 1 /nobreak > nul
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

  rem No need to check for !errorlevel! on mkdir, as all possible values are
  rem valid for our purposes. We do not care if the directory already exists.
  mkdir "%~dp0profiles" 2> nul

  copy "%RawAccelDir%\settings.json" "%~dp0profiles\%1.json" > nul
  if !errorlevel! neq 0 exit /b 10
  echo Current RawAccel settings saved as %1.

  exit /b 0
rem :save_profile

:delete_profile
  call :check_profile 0 %1
  if !errorlevel! neq 0 exit /b !errorlevel!

  rem No need to check !errorlevel! on del as it will always be 0
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

:display_help
echo Quickly save and switch between different RawAccel settings.
echo.
echo USAGE:
echo %~n0 [--save ^| --delete ^| --gui ^| --writer] ^<profile-name^>
echo %~n0 --list [^<profile-name-filter^>]
echo %~n0 --help
echo.
echo   --save      Your current RawAccel settings will be saved into the
echo               specified profile. If this profile already exists,
echo               it will be overwritten.
echo.
echo   --delete    The specified profile will be deleted.
echo.
echo   --gui       Enforce that the RawAccel GUI application is
echo               launched when restoring the profile.
echo.
echo   --writer    Enforce that writer.exe is used
echo               when restoring the profile.
echo.
echo When using %~n0 without any options, the specified profile
echo will be restored and applied to your current RawAccel settings.
echo.
echo   --list      Display a list of saved profiles. You can also specify
echo               a profile name filter, which can include wildcards.
echo.
echo   --help      Display help text.
echo.
exit /b 0
