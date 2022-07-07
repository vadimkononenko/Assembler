@echo off

chcp 1251

    if exist "7-13-IP-05-Kononenko1.obj" del "7-13-IP-05-Kononenko1.obj"
    if exist "7-13-IP-05-Kononenko1.exe" del "7-13-IP-05-Kononenko1.exe"
    if exist "7-13-IP-05-Kononenko2.obj" del "7-13-IP-05-Kononenko2.obj"
    \masm32\bin\ml /c /coff "7-13-IP-05-Kononenko1.asm"
    \masm32\bin\ml /c /coff "7-13-IP-05-Kononenko2.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\Link.exe /SUBSYSTEM:WINDOWS "7-13-IP-05-Kononenko1.obj" "7-13-IP-05-Kononenko2.obj"
    if errorlevel 1 goto errlink
    dir ".*"
    goto TheEnd

  :errlink
    echo _
    echo Link error
    goto TheEnd

  :errasm
    echo _
    echo Assembly Error
    goto TheEnd
    
  :TheEnd

pause
