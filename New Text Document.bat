@echo off
echo Creating AllyCare folder structure...

REM Core folders
mkdir lib\core\constants
mkdir lib\core\utils
mkdir lib\core\errors
mkdir lib\core\network
mkdir lib\core\theme

REM Auth feature
mkdir lib\features\auth\data
mkdir lib\features\auth\presentation\providers
mkdir lib\features\auth\presentation\screens
mkdir lib\features\auth\presentation\widgets

REM Assessment feature
mkdir lib\features\assessment\data
mkdir lib\features\assessment\presentation\providers
mkdir lib\features\assessment\presentation\screens
mkdir lib\features\assessment\presentation\widgets

REM Appointment feature
mkdir lib\features\appointment\data
mkdir lib\features\appointment\presentation\providers
mkdir lib\features\appointment\presentation\screens
mkdir lib\features\appointment\presentation\widgets

REM Profile feature
mkdir lib\features\profile\data
mkdir lib\features\profile\presentation\providers
mkdir lib\features\profile\presentation\screens
mkdir lib\features\profile\presentation\widgets

REM Settings feature
mkdir lib\features\settings\data
mkdir lib\features\settings\presentation\providers
mkdir lib\features\settings\presentation\screens
mkdir lib\features\settings\presentation\widgets

REM Shared folders
mkdir lib\shared\widgets
mkdir lib\shared\providers
mkdir lib\shared\routes
mkdir lib\shared\localization

REM Assets folders
mkdir assets\images\logo
mkdir assets\images\icons
mkdir assets\images\illustrations
mkdir assets\animations
mkdir assets\fonts

echo Folder structure created successfully!
echo.
echo Next steps:
echo 1. Run this batch file in your Flutter project root
echo 2. Add the fonts to assets\fonts folder
echo 3. Add Lottie animations to assets\animations folder
echo 4. Update pubspec.yaml with dependencies
pause