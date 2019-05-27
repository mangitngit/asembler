@echo off
d:\masm611\bin\ml.exe /Fl /Fm /Zi /c %1.asm
if errorlevel 1 goto koniec
d:\masm611\binr\link.exe /codeview %1.obj
:koniec


