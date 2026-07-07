@echo off
setlocal enabledelayedexpansion
title Multi-DNS Connectivity & Latency Tester
cls
echo =======================================================
echo         Multi-DNS Connectivity & Latency Tester        
echo =======================================================
echo.
echo Analyzing connection quality and measuring average latency...
echo Please wait...
echo.

echo -------------------------------------------------------
echo [1/5] Testing Google DNS (8.8.8.8)...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping 8.8.8.8 -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (echo STATUS: ONLINE [Avg Latency: !avg!]) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [2/5] Testing Cloudflare DNS (1.1.1.1)...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping 1.1.1.1 -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (echo STATUS: ONLINE [Avg Latency: !avg!]) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [3/5] Testing Quad9 DNS (9.9.9.9)...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping 9.9.9.9 -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (echo STATUS: ONLINE [Avg Latency: !avg!]) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [4/5] Testing Cisco OpenDNS (208.67.222.222)...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping 208.67.222.222 -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (echo STATUS: ONLINE [Avg Latency: !avg!]) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [5/5] Testing AdGuard DNS (94.140.14.14)...
set "avg=TIMEOUT"
for /f "tokens=4 delims== " %%a in ('ping 94.140.14.14 -n 2 ^| findstr "Average"') do set "avg=%%a"
if not "!avg!"=="TIMEOUT" (echo STATUS: ONLINE [Avg Latency: !avg!]) else (echo STATUS: OFFLINE)
echo.

echo =======================================================
echo  Test Completed. Lower latency means a faster DNS response.
echo =======================================================
pause
