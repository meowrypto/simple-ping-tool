@echo off
setlocal EnableDelayedExpansion
title Professional DNS Latency and Quality Monitor
cls


:: ============================================================
::  ANSI color code setup
:: ============================================================
for /f "tokens=1 delims=#" %%a in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%a"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "ORANGE=%ESC%[38;5;208m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"
set "NEON=%ESC%[38;5;46m"
set "RESET=%ESC%[0m"

:: ============================================================
::  Test settings - edit these to taste
:: ============================================================
set "PING_COUNT=6"

:: Average latency thresholds (ms)
set "GOOD_MAX=70"
set "OK_MAX=200"

:: Jitter thresholds (ms) - lower is more stable
set "JITTER_GOOD_MAX=10"
set "JITTER_OK_MAX=30"

echo %CYAN%=======================================================%RESET%
echo   Professional DNS Latency and Quality Monitor
echo   (now with Jitter / connection stability check)
echo %CYAN%=======================================================%RESET%
echo.
echo Analyzing connection quality, latency and jitter...
echo Please wait...
echo.

call :TestDNS "Google DNS"        "8.8.8.8"
call :TestDNS "Cloudflare DNS"    "1.1.1.1"
call :TestDNS "Quad9 DNS"         "9.9.9.9"
call :TestDNS "Cisco OpenDNS"     "208.67.222.222"
call :TestDNS "AdGuard DNS"       "94.140.14.14"
call :TestDNS "Yandex.DNS"        "77.88.8.8"
call :TestDNS "DNS.WATCH"         "84.200.69.80"
call :TestDNS "CleanBrowsing"     "185.228.168.9"
call :TestDNS "Comodo Secure DNS" "8.26.56.26"
call :TestDNS "Alternate DNS"     "76.76.19.19"

echo %CYAN%=======================================================%RESET%
echo  Test Completed. Color indicators show connection health.
echo %CYAN%=======================================================%RESET%
pause
exit /b


:: ============================================================
::  Subroutine: TestDNS "Display Name" "IP Address"
:: ============================================================
:TestDNS
set "DNS_NAME=%~1"
set "DNS_IP=%~2"

echo -------------------------------------------------------
echo Testing %YELLOW%%DNS_NAME% (%DNS_IP%)%RESET%...

set "tmpfile=%TEMP%\dnscheck_%RANDOM%.txt"
ping %DNS_IP% -n %PING_COUNT% > "%tmpfile%" 2>nul

set "avg="
for /f "tokens=4 delims==" %%a in ('findstr /C:"Average" "%tmpfile%" 2^>nul') do set "avg=%%a"

if not defined avg (
    echo STATUS: %RED%OFFLINE%RESET%
    del "%tmpfile%" >nul 2>nul
    echo.
    exit /b
)

set "avg=!avg: =!"
set "num=!avg:ms=!"

:: ---- collect individual round-trip-time samples for jitter ----
set "sampleCount=0"
for /f "delims=" %%l in ('findstr /R "time[=^<]" "%tmpfile%"') do (
    set "line=%%l"
    set "val="
    echo !line! | findstr /C:"time<1ms" >nul
    if !errorlevel! EQU 0 (
        set "val=0"
    ) else (
        set "t=!line:*time=!"
        set "t=!t:~1!"
        for /f "tokens=1 delims=m" %%n in ("!t!") do set "val=%%n"
    )
    if defined val (
        set /a sampleCount+=1
        set "sample[!sampleCount!]=!val!"
    )
)

:: ---- jitter = mean absolute difference between consecutive samples ----
set "jitterText=N/A"
set "jitterColor=%RESET%"
if !sampleCount! GEQ 2 (
    set "jitterSum=0"
    set "pairCount=0"
    set /a lastIdx=sampleCount-1
    for /l %%i in (1,1,!lastIdx!) do (
        set /a nextIdx=%%i+1
        set /a diff=sample[%%i]-sample[!nextIdx!]
        if !diff! LSS 0 set /a diff=-diff
        set /a jitterSum+=diff
        set /a pairCount+=1
    )
    set /a jitterVal=jitterSum/pairCount
    set "jitterText=!jitterVal!ms"

    if !jitterVal! LSS %JITTER_GOOD_MAX% (
        set "jitterColor=%GREEN%"
    ) else if !jitterVal! LEQ %JITTER_OK_MAX% (
        set "jitterColor=%ORANGE%"
    ) else (
        set "jitterColor=%RED%"
    )
)

:: ---- latency color ----
if !num! LSS %GOOD_MAX% (
    set "latColor=%GREEN%"
) else if !num! LEQ %OK_MAX% (
    set "latColor=%ORANGE%"
) else (
    set "latColor=%RED%"
)

echo STATUS: %NEON%ONLINE%RESET% [Avg Latency: !latColor!!avg!%RESET%] [Jitter: !jitterColor!!jitterText!%RESET%]

del "%tmpfile%" >nul 2>nul
echo.
exit /b
