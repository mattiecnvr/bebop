@echo off
rem Building Nuget bebop-tools Nuget package

cd %~dp0

SETLOCAL
SET CACHED_NUGET=%LocalAppData%\NuGet\NuGet.exe

IF EXIST %CACHED_NUGET% goto copynuget
echo Downloading latest version of NuGet.exe...
IF NOT EXIST %LocalAppData%\NuGet md %LocalAppData%\NuGet
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile '%CACHED_NUGET%'"

:copynuget
IF EXIST .nuget\NuGet.exe goto restore
md .nuget
copy %CACHED_NUGET% .nuget\NuGet.exe > nul
.nuget\NuGet.exe Update -Self

:restore
IF NOT EXIST packages.config goto run
.nuget\NuGet.exe Install packages.config -OutputDirectory packages -ExcludeVersion

:run
set /p Build=<version.txt
.nuget\NuGet.exe Pack bebop-tools.nuspec -OutputDirectory packages -Version %Build%