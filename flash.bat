sb_loader.exe -f u-boot.bin
fastboot boot format-emmc.img
timeout /t 30
sb_loader.exe -f u-boot.bin
fastboot.exe update update.zip
