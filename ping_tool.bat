@echo off
setlocal enabledelayedexpansion
title Professional DNS Latency & Quality Monitor
cls

:: تعریف کدهای رنگی ANSI
set "ESC="
for /f "tokens=1 delims=#" %%a in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%a"

set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "ORANGE=%ESC%[38;5;208m"
set "CYAN=%ESC%[96m"
set "RESET=%ESC%[0m"

echo %CYAN%=======================================================%RESET%
echo          Professional DNS Latency & Quality Monitor        
echo %CYAN%=======================================================%RESET%
echo.
echo Analyzing connection quality and measuring average latency...
echo Please wait...
echo.

:: [1/5] Google
set "DNS_NAME=Google DNS"
set "DNS_IP=8.8.8.8"
echo -------------------------------------------------------
echo Testing %YELLOW%%DNS_NAME% (%DNS_IP%)%RESET%...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping %DNS_IP% -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (
    set "num=!avg:ms=!"
    if !num! LSS 60 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %GREEN%!avg!%RESET%]
    ) else if !num! LSS 150 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %ORANGE%!avg!%RESET%]
    ) else (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %RED%!avg!%RESET%]
    )
) else (
    echo STATUS: %RED%OFFLINE%RESET%
)
echo.

:: [2/5] Cloudflare
set "DNS_NAME=Cloudflare DNS"
set "DNS_IP=1.1.1.1"
echo -------------------------------------------------------
echo Testing %YELLOW%%DNS_NAME% (%DNS_IP%)%RESET%...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping %DNS_IP% -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (
    set "num=!avg:ms=!"
    if !num! LSS 60 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %GREEN%!avg!%RESET%]
    ) else if !num! LSS 150 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %ORANGE%!avg!%RESET%]
    ) else (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %RED%!avg!%RESET%]
    )
) else (
    echo STATUS: %RED%OFFLINE%RESET%
)
echo.

:: [3/5] Quad9
set "DNS_NAME=Quad9 DNS"
set "DNS_IP=9.9.9.9"
echo -------------------------------------------------------
echo Testing %YELLOW%%DNS_NAME% (%DNS_IP%)%RESET%...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping %DNS_IP% -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (
    set "num=!avg:ms=!"
    if !num! LSS 60 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %GREEN%!avg!%RESET%]
    ) else if !num! LSS 150 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %ORANGE%!avg!%RESET%]
    ) else (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %RED%!avg!%RESET%]
    )
) else (
    echo STATUS: %RED%OFFLINE%RESET%
)
echo.

:: [4/5] Cisco OpenDNS
set "DNS_NAME=Cisco OpenDNS"
set "DNS_IP=208.67.222.222"
echo -------------------------------------------------------
echo Testing %YELLOW%%DNS_NAME% (%DNS_IP%)%RESET%...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping %DNS_IP% -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (
    set "num=!avg:ms=!"
    if !num! LSS 60 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %GREEN%!avg!%RESET%]
    ) else if !num! LSS 150 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %ORANGE%!avg!%RESET%]
    ) else (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %RED%!avg!%RESET%]
    )
) else (
    echo STATUS: %RED%OFFLINE%RESET%
)
echo.

:: [5/5] AdGuard DNS
set "DNS_NAME=AdGuard DNS"
set "DNS_IP=94.140.14.14"
echo -------------------------------------------------------
echo Testing %YELLOW%%DNS_NAME% (%DNS_IP%)%RESET%...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping %DNS_IP% -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (
    set "num=!avg:ms=!"
    if !num! LSS 60 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %GREEN%!avg!%RESET%]
    ) else if !num! LSS 150 (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %ORANGE%!avg!%RESET%]
    ) else (
        echo STATUS: %GREEN%ONLINE%RESET% [Avg Latency: %RED%!avg!%RESET%]
    )
) else (
    echo STATUS: %RED%OFFLINE%RESET%
)
echo.

echo %CYAN%=======================================================%RESET%
echo  Test Completed. Color indicators show connection health.
echo %CYAN%=======================================================%RESET%
pause
