@echo off
echo Stopping any existing SyncRide server...
taskkill /F /IM node.exe /T >nul 2>&1
echo.
echo Starting SyncRide Server...
echo.
node backend/server.js
pause
