@echo off
md ex
expand -f:* WindowsTH-RSAT_WS_1709-x64.msu ex\
cd ex
md ex
copy ..\unattend_x64.xml ex\
expand -f:* WindowsTH-KB2693643-x64.cab ex\
cd ex
dism /online /apply-unattend="unattend_x64.xml"
cd ..\
dism /online /Add-Package /PackagePath:"WindowsTH-KB2693643-x64.cab"
cd ..\
rmdir ex /s /q