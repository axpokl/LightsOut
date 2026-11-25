del *.exe
for /f %%g in ('dir /b "diandeng*.pas"') do fpc "%%g"
for /f %%g in ('dir /b "*calc*.pas"') do fpc "%%g"
del *.obj
del *.ppu
del *.o
del *.or
del *.a
pause
