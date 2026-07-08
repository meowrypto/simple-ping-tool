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
::  Latency thresholds (ms) - edit these to taste
::  < GOOD_MAX        -> GREEN
::  GOOD_MAX..OK_MAX   -> ORANGE
::  > OK_MAX           -> RED
:: ============================================================
set "GOOD_MAX=70"
set "OK_MAX=200"

echo %CYAN%=======================================================%RESET%
echo   Professional DNS Latency and Quality Monitor
echo %CYAN%=======================================================%RESET%
echo.
echo Analyzing connection quality and measuring average latency...
echo Please wait...
echo.

call :TestDNS "Google DNS"     "8.8.8.8"
call :TestDNS "Cloudflare DNS" "1.1.1.1"
call :TestDNS "Quad9 DNS"      "9.9.9.9"
call :TestDNS "Cisco OpenDNS"  "208.67.222.222"
call :TestDNS "AdGuard DNS"    "94.140.14.14"

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

set "avg="
for /f "tokens=4 delims==" %%a in ('ping %DNS_IP% -n 2 ^| findstr /C:"Average"') do set "avg=%%a"

if not defined avg (
    echo STATUS: %RED%OFFLINE%RESET%
    echo.
    exit /b
)

:: strip spaces left over from parsing, e.g. " 22ms" -^> "22ms"
set "avg=!avg: =!"
set "num=!avg:ms=!"

if !num! LSS %GOOD_MAX% (
    echo STATUS: %NEON%ONLINE%RESET% [Avg Latency: %GREEN%!avg!%RESET%]
) else if !num! LEQ %OK_MAX% (
    echo STATUS: %NEON%ONLINE%RESET% [Avg Latency: %ORANGE%!avg!%RESET%]
) else (
    echo STATUS: %NEON%ONLINE%RESET% [Avg Latency: %RED%!avg!%RESET%]
)
echo.
exit /b
