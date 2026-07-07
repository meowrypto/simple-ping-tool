@echo off
title Multi-DNS Internet Connectivity Tester
cls
echo =======================================================
echo          Multi-DNS Internet Connectivity Tester        
echo =======================================================
echo.
echo Checking your internet connection via 5 major global DNS servers...
echo Please wait...
echo.

echo -------------------------------------------------------
echo [1/5] Pinging Google DNS (8.8.8.8)...
ping 8.8.8.8 -n 2 | findstr "Packets: Approximate"
if %errorlevel% equ 0 (echo STATUS: ONLINE) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [2/5] Pinging Cloudflare DNS (1.1.1.1)...
ping 1.1.1.1 -n 2 | findstr "Packets: Approximate"
if %errorlevel% equ 0 (echo STATUS: ONLINE) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [3/5] Pinging Quad9 DNS (9.9.9.9)...
ping 9.9.9.9 -n 2 | findstr "Packets: Approximate"
if %errorlevel% equ 0 (echo STATUS: ONLINE) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [4/5] Pinging Cisco OpenDNS (208.67.222.222)...
ping 208.67.222.222 -n 2 | findstr "Packets: Approximate"
if %errorlevel% equ 0 (echo STATUS: ONLINE) else (echo STATUS: OFFLINE)
echo.

echo -------------------------------------------------------
echo [5/5] Pinging AdGuard DNS (94.140.14.14)...
ping 9.9.9.9 -n 2 | findstr "Packets: Approximate"
if %errorlevel% equ 0 (echo STATUS: ONLINE) else (echo STATUS: OFFLINE)
echo.

echo =======================================================
echo  Test Completed. If most services are ONLINE, your internet is fine.
echo =======================================================
pause
