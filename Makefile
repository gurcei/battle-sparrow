bas:
	./c1541.exe C:/Users/GurceI/AppData/Roaming/xemu-lgb/mega65/hdos/MEGA65.D81 -read "bs3" BS3.PRG
	./petcat -65 -o BS3.BAS BS3.PRG

bas2prg:
	./petcat -w65 -o BS3.PRG BS3.BAS
	./c1541.exe C:/Users/GurceI/AppData/Roaming/xemu-lgb/mega65/hdos/MEGA65.D81 -delete bs3 -write BS3.PRG "bs3"
