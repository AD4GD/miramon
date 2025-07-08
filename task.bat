@echo off
setlocal enabledelayedexpansion

:: collect arguments as `case_study:res` pairs
set pairs=
set AUTO_CONFIRM=true
:: set default Miramon installation directory
set MIRAMON_DIR=D:\Programs\Miramon

:collect_args
if "%~1"=="" goto process

:: DEBUG: show the argument
echo Processing argument: %~1

:: add sleep timeout
timeout /t 1 /nobreak >nul

:: check if the argument is auto_confirm:true or auto_confirm:false and set it
if /i "%~1"=="auto_confirm:true" (
    set AUTO_CONFIRM=true
    shift
    goto collect_args
) else if /i "%~1"=="auto_confirm:false" (
    set AUTO_CONFIRM=false
    shift
    goto collect_args
)

:: check if the argument is miramon_dir:xxx and set it
if /i "%~1"=="miramon_dir:%~2" (
    set MIRAMON_DIR=%~2
    shift
    shift
    goto collect_args
)

:: skip 'auto_confirm' argument from being appended to 'pairs'
if "%~1" neq "auto_confirm" if "%~1" neq "true" if "%~1" neq "false" (
    set pairs=%pairs% %~1
)

shift
goto collect_args

:process
echo ----------------------------
echo Input parameters: %pairs%
echo Auto-confirm: %AUTO_CONFIRM%
echo MiraMon directory: %MIRAMON_DIR%
echo ----------------------------

timeout /t 3 /nobreak >nul

:: get current directory
set ROOT_DIR=%cd%

echo %ROOT_DIR%
echo %MIRAMON_DIR%

echo TEMP is: %TEMP%
if not exist "%TEMP%" (
    echo ERROR: TEMP path "%TEMP%" does not exist!
)

:: create auto-confirm script for MiraMon ICT commands (pop up windows to confirm overwriting output files)
set "VBSFILE=auto_confirm.vbs"

if /i "%AUTO_CONFIRM%"=="true" (
    (
        echo Set WshShell = CreateObject^("WScript.Shell"^)
        echo WScript.Sleep 2000
        echo WshShell.SendKeys "{ENTER}"
    ) > "%VBSFILE%"
)

if exist "!VBSFILE!" (
    echo VBS script successfully created at: !VBSFILE!
) else (
    echo VBScript file was NOT created.
)

:: loop over each pair
for %%P in (%pairs%) do (
    echo Processing pair: %%P
    :: split case_study and resolution
    for /f "tokens=1,2,3 delims=:" %%A in ("%%P") do (
        set CASE=%%A
        set RES=%%B
        set RADIUS=%%C

        echo ----------------------------
        echo Processing case: !CASE! with resolution: !RES!, RADIUS: !RADIUS!
        timeout /t 3 /nobreak >nul

        :: set directory paths
        set BASE_DIR=%ROOT_DIR%\data\!CASE!
        set IMPEDANCE_DIR=!BASE_DIR!\impedance
        set AFFINITY_DIR=!BASE_DIR!\affinity
        set ICT_DIR=!BASE_DIR!\ict

        :: loop through files in impedance folder
        for %%F in ("!IMPEDANCE_DIR!\*.img") do (
            echo Processing file: %%~nxF
            timeout /t 3 /nobreak >nul

            set FILENAME=%%~nF
            set AFFINITY_FILE=!AFFINITY_DIR!\!FILENAME:impedance=affinity!.img
            set ICT_FILE=!ICT_DIR!\!FILENAME:impedance=ict!.img
            
            if /i "!AUTO_CONFIRM!"=="true" (
                start "" wscript.exe "!VBSFILE!"
            )

            call "%MIRAMON_DIR%\ICT" NUL !RES! !RADIUS! "%%F" "!AFFINITY_FILE!" -1 -1 0 "!ICT_FILE!" /DT="%MIRAMON_DIR%"
        )
    )
)

:: clean up
if /i "%AUTO_CONFIRM%"=="true" (
    del "%VBSFILE%" >nul 2>&1
)

endlocal