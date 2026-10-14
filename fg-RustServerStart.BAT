@echo off
setlocal EnableDelayedExpansion

if /I "%~1"=="__FG_RUN__" goto MAIN
"%ComSpec%" /v:on /c call "%~f0" __FG_RUN__
set "FG_EXIT_CODE=!ERRORLEVEL!"
echo.
if not "!FG_EXIT_CODE!"=="0" (
    echo [UYARI] Script hata kodu !FG_EXIT_CODE! ile durdu. Yukaridaki hata mesajlarini kontrol edin.
)
echo [*] Konsol penceresi otomatik kapanmayacak.
pause
exit /b !FG_EXIT_CODE!

:MAIN

:: ========================================================================
:: fg-RustServerStart.BAT
:: Tam Otomatik Rust Dedicated Server Scripti
:: Versiyon: 1.5.0
:: ========================================================================

:: ========================================================================
:: [1] KULLANICI YAPILANDIRMA BÖLÜMÜ
:: ========================================================================

:: --- 1.1 Sunucu Temel Ayarları ---
set "SERVER_HOSTNAME=feyioz Rust Server"
set "SERVER_DESCRIPTION=Powered by feyioz - Tam otomatik sunucu"
set "SERVER_URL=https://feyioz.com"
set "SERVER_HEADERIMAGE=https://feyioz.com/banner.jpg"
:: Sunucu logosu (tarayici ve Rust+ uygulamasinda gosterilir). Bos = gonderilmez.
set "SERVER_LOGOIMAGE="
set "SERVER_IDENTITY=feyioz_rust"
set "SERVER_MAXPLAYERS=50"
set "SERVER_SEED=auto"
set "SERVER_WORLDSIZE=4000"
set "SERVER_LEVEL=Procedural Map"
set "SERVER_LEVELURL="
set "SERVER_TAGS=monthly,vanilla,EU"

:: --- 1.2 Ağ Ayarları ---
set "SERVER_IP=0.0.0.0"
set "SERVER_PORT=28015"
:: Bos birakilirsa otomatik hesaplanir: en buyuk port (oyun/RCON) + 1. Oyun portundan farkli olmalidir.
set "SERVER_QUERYPORT="
set "RCON_IP=0.0.0.0"
set "RCON_PORT=28016"
set "RCON_PASSWORD=change_me_rcon_pass"
set "RCON_WEB=1"

:: --- 1.3 Rust+ Companion App Ayarları ---
set "APP_PORT=28082"
set "APP_LISTENIP="
set "APP_PUBLICIP="
set "RUSTPLUS_ENABLED=1"

:: --- 1.4 Güvenlik & Anti-Cheat Ayarları ---
set "SERVER_SECURE=1"
set "SERVER_EAC=1"
set "SERVER_ENCRYPTION=1"
set "SERVER_STABILITY=1"
set "CODELOCK_LOCKOUTCOOLDOWN=900"
set "CODELOCK_MAXFAILEDATTEMPTS=8"

:: --- 1.5 Performans Ayarları ---
set "SERVER_TICKRATE=30"
:: Sunucu FPS limiti (+fps.limit olarak gonderilir; motor varsayilani 256)
set "SERVER_FPSLIMIT=120"
set "SERVER_SAVEINTERVAL=600"
set "GC_INTERVAL="
set "GC_BUFFERCOUNT="
set "ENTITYBATCHSIZE="
set "GLOBAL_MAXTHREADS=8"

:: --- 1.6 Decay & Upkeep Ayarları ---
set "DECAY_SCALE=1"
set "DECAY_TICK=600"
set "DECAY_UPKEEP=1"
set "DECAY_UPKEEP_PERIOD_MINUTES=1440"
:: Grup bakim vergisi (Eylul 2026 "Breach and Clear" guncellemesi). 0 = vergi kapali.
set "DECAY_UPKEEP_GROUP_SCALING=1"
set "DECAY_DURATION_TOPTIER="
set "DECAY_DURATION_METAL="
set "DECAY_DURATION_STONE="
set "DECAY_DURATION_WOOD="
set "DECAY_DURATION_TWIG="

:: --- 1.7 Hayvan & NPC Popülasyon Ayarları ---
:: Not: wolf.population, Wolves2 guncellemesiyle wolf2.population olarak yeniden adlandirildi.
set "BEAR_POPULATION=2"
set "BOAR_POPULATION=5"
set "CHICKEN_POPULATION=3"
set "STAG_POPULATION=3"
set "WOLF2_POPULATION=2"
set "POLARBEAR_POPULATION=1"
set "TIGER_POPULATION=0.5"
set "PANTHER_POPULATION=0.5"
set "CROCODILE_POPULATION=1"
set "SNAKEHAZARD_POPULATION=5"
set "NPCS_ENABLED=1"
set "AI_TICKRATE=5"
set "AI_IGNOREPLAYERS=0"
:: Ileri duzey performans anahtarlari. Bos = varsayilan (1).
set "AI_MOVE="
set "AI_THINK="

:: --- 1.8 Oyun İçi Event Ayarları ---
set "CARGOSHIP_ENABLED=1"
set "CARGOSHIP_DURATION_MINUTES=50"
set "CARGOSHIP_LOOT_ROUNDS=3"
set "CARGOSHIP_LOOT_SPACING_MINUTES=10"
set "HELI_BULLETDMGSCALE="
set "BRADLEY_ENABLED=1"
set "MISSIONS_ENABLED=1"

:: --- 1.9 Oynanış & Gelişmiş Ayarları ---
set "SERVER_PVE=0"
:: craft.instant vanilla surumunden kaldirildi; yalnizca eski surumler/pluginler icin doldurun.
set "CRAFT_INSTANT="
:: Radyasyon bolgelerini acar/kapatir.
set "SERVER_RADIATION=1"
:: Maksimum ekip (team) boyutu. 0 = takimlar kapali.
set "SERVER_TEAMMAXSIZE=8"
set "SERVER_ITEMDESPAWN=180"
set "SERVER_BRANCH=public"

:: --- 1.10 Dizin & Güncelleme Ayarları ---
set "STEAMCMD_DIR=%~dp0steamcmd"
set "SERVER_DIR=%~dp0server"
set "LOG_DIR=%~dp0logs"
set "AUTO_UPDATE=1"
:: 1 = guncellemede dosya dogrulamasi yapilir (guvenli, yavas). 0 = validate atlanir (hizli).
set "STEAMCMD_VALIDATE=1"
:: Bu gun sayisindan eski log dosyalari baslangicta silinir. 0 = temizlik kapali.
set "LOG_RETENTION_DAYS=14"
set "ENABLE_UMOD=0"

:: --- 1.11 Crash & Yeniden Başlatma Ayarları ---
set "CRASH_RESTART=1"
set "CRASH_WAIT_SECONDS=30"
set "MAX_CRASH_RESTARTS=5"
:: Sunucu bu sure boyunca kesintisiz ayakta kaldiysa crash sayaci sifirlanir (sn).
set "CRASH_RESET_UPTIME_SECONDS=300"

:: --- 1.12 Yönetici & Yetki Ayarları ---
:: Birden fazla Steam64ID eklemek için virgülle ayırın. Örnek: "76561198000000001,76561198000000002"
set "SERVER_OWNERS="
set "SERVER_MODERATORS="

:: --- 1.13 Ekim 2026 "Livestock" Ayarları ---
:: Yeni navmesh (Ekim 2026) artik varsayilan olarak acik. 1 = eski navmesh (-useOldNavmesh).
set "SERVER_OLD_NAVMESH=0"
:: Air Wolf helipad onarim zorunlulugu. 1 = vanilla davranis, 0 = onarim gerekmez.
set "VEHICLE_PADREPAIRSREQUIRED=1"
:: Helipadi zorla bozuk (0) / onarilmis (1) duruma alir. Bos = dokunulmaz.
set "VEHICLE_SETREPAIRABLEPADS="
:: Powergrid sigorta curumesi (Ekim 2026): dusuk/yuksel oyuncu esikleri ve dusuk pop. carpani.
set "POWERGRID_FUSEDECAYLOWPOP=10"
set "POWERGRID_FUSEDECAYHIGHPOP=100"
set "POWERGRID_FUSEDECAYLOWPOPSCALE=4"
:: Sandbag yukseltmesinde hasar orani korunur (vanilla: 1).
set "SERVER_UPGRADE_KEEPS_HEALTH=1"
:: Ciftlik hayvanlari. Bos = vanilla. Gecerli convar adlari icin sunucu konsolunda: find livestock
set "COW_POPULATION="
set "SHEEP_POPULATION="

:: --- 1.14 Test & Tani Ayarları ---
:: 1 = kuru calistirma: kurulum, firewall ve sunucu baslatma yapilmaz; ozet ekrana yazilir.
set "FG_DRY_RUN=0"

:: ========================================================================
:: [2] EKRAN & RENK AYARLARI
:: ========================================================================
title fg-RustServer [%SERVER_IDENTITY%]
color 0A
mode con cols=120 lines=30

echo ===================================================
echo   fg-RustServerStart.BAT - Tam Otomatik Kurulum
echo ===================================================
echo.

:: ========================================================================
:: [3] ÖN KONTROL UYARILARI
:: ========================================================================
:: ONEMLI: Blok icindeki echo satirlarinda '!' ve parantez kullanilmaz (! ve () cmd tarafindan yorumlanir).
echo [*] Yapilandirma on kontrolleri yapiliyor...
if /I "%RCON_PASSWORD%"=="change_me_rcon_pass" echo [UYARI] RCON_PASSWORD hala varsayilan deger. Lutfen degistirin.
if "!SERVER_OWNERS!"=="" echo [UYARI] SERVER_OWNERS bos. Sunucuda yonetici yetkisi olan kimse olmayacak.
if /I "%SERVER_EAC%"=="0" echo [UYARI] SERVER_EAC=0 iken sunucunuz listede gorunmez, sadece IP ile baglanilir.
if "%FG_DRY_RUN%"=="1" echo [*] Kuru calistirma modu aktif: sistemde hicbir degisiklik yapilmayacak.
echo.

:: ========================================================================
:: [4] YÖNETİCİ YETKİ KONTROLÜ
:: ========================================================================
if "%FG_DRY_RUN%"=="1" (
    echo [*] Kuru calistirma: yonetici yetki kontrolu ve UAC istegi atlandi.
) else (
    echo [*] Yonetici yetkileri kontrol ediliyor...
    net session >nul 2>&1
    if !errorLevel! equ 0 (
        echo [+] Yonetici yetkileri basariyla dogrulandi.
    ) else (
        echo [-] Yonetici yetkisi bulunamadi. UAC istegi gonderiliyor...
        powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/k \"\"%~dpnx0\"\"' -Verb RunAs"
        exit /b
    )
)
echo.

:: ========================================================================
:: [5] WINDOWS SERVER 2022 OPTİMİZASYONLARI
:: ========================================================================
if "%FG_DRY_RUN%"=="1" (
    echo [*] Kuru calistirma: guc plani ^(powercfg^) degistirilmedi.
) else (
    echo [*] Windows Server 2022 / Performans optimizasyonlari uygulaniyor...
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    echo [+] Guc plani 'Yuksek Performans' olarak ayarlandi.
)
echo.

:: ========================================================================
:: [6] DİZİN YAPISININ OLUŞTURULMASI
:: ========================================================================
if "%FG_DRY_RUN%"=="1" (
    set "FG_TEMP_ROOT=%TEMP%\fg-rustserver-dryrun"
    set "STEAMCMD_DIR=!FG_TEMP_ROOT!\steamcmd"
    set "SERVER_DIR=!FG_TEMP_ROOT!\server"
    set "LOG_DIR=!FG_TEMP_ROOT!\logs"
    echo [*] Kuru calistirma: gercek dizinlere dokunulmadi, gecici alan kullanilacak: !FG_TEMP_ROOT!
)
echo [*] Dizin yapisi kontrol ediliyor...
if not exist "%STEAMCMD_DIR%" mkdir "%STEAMCMD_DIR%"
if not exist "%SERVER_DIR%" mkdir "%SERVER_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
echo [+] Dizinler hazir.

:: Eski log dosyalarini temizle (disk sismesini onler)
if not "%LOG_RETENTION_DAYS%"=="0" (
    forfiles /p "%LOG_DIR%" /m server_*.log /d -%LOG_RETENTION_DAYS% /c "cmd /c del /q @path" >nul 2>&1
    echo [+] %LOG_RETENTION_DAYS% gunden eski loglar temizlendi.
)
echo.

:: ========================================================================
:: [7] STEAMCMD KONTROLÜ VE KURULUMU
:: ========================================================================
if "%FG_DRY_RUN%"=="1" (
    echo [*] Kuru calistirma: SteamCMD indirme/kurulum adimi atlandi.
) else (
    if not exist "%STEAMCMD_DIR%\steamcmd.exe" (
        echo [*] SteamCMD bulunamadi. İndiriliyor...
        set "STEAMCMD_DL_OK=0"
        for /L %%i in (1,1,3) do (
            if "!STEAMCMD_DL_OK!"=="0" (
                set "ZIP_SIZE=0"
                if exist "%STEAMCMD_DIR%\steamcmd.zip" del /q "%STEAMCMD_DIR%\steamcmd.zip"
                powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile '%STEAMCMD_DIR%\steamcmd.zip'"
                if exist "%STEAMCMD_DIR%\steamcmd.zip" for %%Z in ("%STEAMCMD_DIR%\steamcmd.zip") do set "ZIP_SIZE=%%~zZ"
                if !ZIP_SIZE! gtr 100000 (
                    echo [*] SteamCMD arsivden cikariliyor...
                    powershell -NoProfile -Command "Expand-Archive -Path '%STEAMCMD_DIR%\steamcmd.zip' -DestinationPath '%STEAMCMD_DIR%' -Force"
                    if exist "%STEAMCMD_DIR%\steamcmd.exe" set "STEAMCMD_DL_OK=1"
                )
                if "!STEAMCMD_DL_OK!"=="0" (
                    echo [-] SteamCMD indirme/kurulum basarisiz oldu. Tekrar deneniyor... [%%i/3]
                    timeout /t 5 /nobreak >nul
                )
            )
        )
        if exist "%STEAMCMD_DIR%\steamcmd.zip" del /q "%STEAMCMD_DIR%\steamcmd.zip"
        if "!STEAMCMD_DL_OK!"=="0" (
            echo [-] HATA: SteamCMD kurulamadi. Internet baglantinizi ve guvenlik duvarini kontrol edin.
            pause
            exit /b 1
        )
        echo [+] SteamCMD kurulumu tamamlandi.
    ) else (
        echo [+] SteamCMD zaten kurulu.
    )
)
echo.

:: ========================================================================
:: [8] RUST SERVER KURULUMU/GÜNCELLEMESİ
:: ========================================================================
:: STEAMCMD_VALIDATE=1 ise +app_update komutuna 'validate' eklenir.
set "STEAMCMD_VALIDATE_FLAG="
if "%STEAMCMD_VALIDATE%"=="1" set "STEAMCMD_VALIDATE_FLAG=validate"
if "%FG_DRY_RUN%"=="1" (
    echo [*] Kuru calistirma: SteamCMD calistirilmadi. Calistirilacak komut:
    if /I "%SERVER_BRANCH%"=="public" (
        echo     "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 258550 %STEAMCMD_VALIDATE_FLAG% +quit
    ) else (
        echo     "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 258550 -beta %SERVER_BRANCH% %STEAMCMD_VALIDATE_FLAG% +quit
    )
    goto FG_UPDATE_DONE
)
if "%AUTO_UPDATE%"=="1" (
    echo [*] Rust Dedicated Server guncelleniyor/kuruluyor...
    set "STEAMCMD_SUCCESS=0"
    for /L %%i in (1,1,3) do (
        if "!STEAMCMD_SUCCESS!"=="0" (
            if /I "%SERVER_BRANCH%"=="public" (
                "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 258550 !STEAMCMD_VALIDATE_FLAG! +quit
            ) else (
                "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 258550 -beta %SERVER_BRANCH% !STEAMCMD_VALIDATE_FLAG! +quit
            )
            if !errorlevel! equ 0 (
                set "STEAMCMD_SUCCESS=1"
            ) else (
                if %%i lss 3 (
                    echo [-] SteamCMD hata verdi veya 'CWorkThreadPool' uyarisi alindi. Tekrar deneniyor... [%%i/3]
                    timeout /t 5 /nobreak >nul
                )
            )
        )
    )
    if "!STEAMCMD_SUCCESS!"=="0" (
        echo [-] SteamCMD guncelleme sirasinda kalici bir hata olustu.
        echo [-] Lutfen internet baglantinizi ve SERVER_BRANCH ayarini kontrol edin.
        pause
        exit /b 1
    ) else (
        echo [+] Rust Server guncellemesi basarili.
    )
) else (
    echo [*] Otomatik guncelleme devre disi.
)
:FG_UPDATE_DONE
echo.

:: ========================================================================
:: [9] UMOD/OXIDE KURULUMU (Opsiyonel)
:: ========================================================================
if "%FG_DRY_RUN%"=="1" (
    echo [*] Kuru calistirma: uMod/Oxide kurulum adimi atlandi.
) else (
if "%ENABLE_UMOD%"=="1" (
    echo [*] uMod/Oxide surumleri kontrol ediliyor...
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/OxideMod/Oxide.Rust/releases' | Select-Object -First 5; Write-Host '==================================================='; Write-Host '       uMod/Oxide Kurulum Menusu'; Write-Host '==================================================='; $i = 1; foreach ($r in $releases) { Write-Host ('[' + $i + '] ' + $r.tag_name); $i++ }; Write-Host '[0] Iptal et / Atla'; Write-Host '==================================================='; $selection = -1; while ($true) { $input = Read-Host 'Lutfen kurmak istediginiz surumu secin (0-5)'; if ([int]::TryParse($input, [ref]$selection) -and $selection -ge 0 -and $selection -le 5) { break; } else { Write-Host '[-] Gecersiz secim. Lutfen 0 ile 5 arasinda bir sayi girin.' -ForegroundColor Red } }; if ($selection -eq 0) { Write-Host '[*] uMod kurulumu atlandi.' -ForegroundColor Yellow; exit 0 }; $selectedRelease = $releases[$selection - 1]; $version = $selectedRelease.tag_name; $asset = $selectedRelease.assets | Where-Object { $_.name -eq 'Oxide.Rust.zip' }; if (-not $asset) { Write-Host '[-] HATA: Secilen surum icin Oxide.Rust.zip bulunamadi.' -ForegroundColor Red; exit 1 }; $zipFile = '%SERVER_DIR%\Oxide.Rust.zip'; Write-Host ('[*] ' + $version + ' indiriliyor...') -ForegroundColor Cyan; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipFile; Write-Host '[*] uMod dosyalari arsivden cikariliyor...' -ForegroundColor Cyan; Add-Type -AssemblyName System.IO.Compression.FileSystem; $archive = [System.IO.Compression.ZipFile]::OpenRead($zipFile); foreach ($entry in $archive.Entries) { $destinationPath = [System.IO.Path]::Combine('%SERVER_DIR%', $entry.FullName); $destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath); if (-not (Test-Path $destinationDir)) { New-Item -ItemType Directory -Path $destinationDir | Out-Null }; if ($entry.Name -ne '') { try { if (Test-Path $destinationPath) { Set-ItemProperty -Path $destinationPath -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue; Remove-Item -Path $destinationPath -Force -ErrorAction Stop }; [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destinationPath, $true) } catch { Write-Host ('[-] HATA: ' + $destinationPath + ' yazilamadi. ' + $_.Exception.Message) -ForegroundColor Red; exit 1 } } }; $archive.Dispose(); $checkFile = [System.IO.Path]::Combine('%SERVER_DIR%', 'RustDedicated_Data', 'Managed', 'Oxide.Core.dll'); if (-not (Test-Path $checkFile)) { Write-Host '[-] HATA: Oxide dosyalari eksik.' -ForegroundColor Red; exit 1 } else { Write-Host ('[+] uMod kurulumu (' + $version + ') basariyla tamamlandi.') -ForegroundColor Green }"
    if !errorlevel! neq 0 (
        echo [-] UYARI: uMod/Oxide kurulumunda kritik bir hata olustu. Lutfen yukaridaki kirmizi mesajlari kontrol edin.
        pause
        exit /b 1
    )
) else (
    echo [*] uMod/Oxide kurulumu devre disi.
)
)
echo.

:: ========================================================================
:: [10] FIREWALL KURALLARI
:: ========================================================================
:: Queryport otomatik hesaplama: bos ise en buyuk port (oyun/RCON) + 1.
:: Facepunch (Subat 2023 ag guncellemesi): queryport acik degilse sunucu listede gorunmez.
set "QUERYPORT_FINAL=%SERVER_QUERYPORT%"
if "%SERVER_QUERYPORT%"=="" (
    set /a QUERYPORT_FINAL=SERVER_PORT+1
    if %RCON_PORT% gtr %SERVER_PORT% set /a QUERYPORT_FINAL=RCON_PORT+1
)

if "%FG_DRY_RUN%"=="1" (
    echo [*] Kuru calistirma: firewall kurallari degistirilmedi. Eklenecek kurallar:
    echo     - UDP %SERVER_PORT% ^(oyun portu^)
    echo     - TCP %RCON_PORT% ^(RCON^)
    if "%RUSTPLUS_ENABLED%"=="1" echo     - TCP %APP_PORT% ^(Rust+^)
    echo     - UDP %QUERYPORT_FINAL% ^(queryport^)
    goto FG_FIREWALL_DONE
)

echo [*] Windows Firewall kurallari kontrol ediliyor...
netsh advfirewall firewall show rule name="fg-RustServer - Port %SERVER_PORT% UDP" >nul 2>&1
if errorlevel 1 (
    netsh advfirewall firewall add rule name="fg-RustServer - Port %SERVER_PORT% UDP" dir=in action=allow protocol=UDP localport=%SERVER_PORT% profile=any enable=yes >nul 2>&1
    if errorlevel 1 (
        echo [-] HATA: Firewall kurali eklenemedi: UDP %SERVER_PORT%
        echo [-] Windows Defender Firewall servisini ve yonetici yetkisini kontrol edin.
        exit /b 1
    )
    echo [+] Firewall kurali eklendi: UDP %SERVER_PORT%
) else (
    echo [+] Firewall kurali zaten mevcut: UDP %SERVER_PORT%
)

netsh advfirewall firewall show rule name="fg-RustServer - Port %RCON_PORT% TCP" >nul 2>&1
if errorlevel 1 (
    netsh advfirewall firewall add rule name="fg-RustServer - Port %RCON_PORT% TCP" dir=in action=allow protocol=TCP localport=%RCON_PORT% profile=any enable=yes >nul 2>&1
    if errorlevel 1 (
        echo [-] HATA: Firewall kurali eklenemedi: TCP %RCON_PORT%
        echo [-] Windows Defender Firewall servisini ve yonetici yetkisini kontrol edin.
        exit /b 1
    )
    echo [+] Firewall kurali eklendi: TCP %RCON_PORT%
) else (
    echo [+] Firewall kurali zaten mevcut: TCP %RCON_PORT%
)

if "%RUSTPLUS_ENABLED%"=="1" (
    netsh advfirewall firewall show rule name="fg-RustServer - Port %APP_PORT% TCP" >nul 2>&1
    if errorlevel 1 (
        netsh advfirewall firewall add rule name="fg-RustServer - Port %APP_PORT% TCP" dir=in action=allow protocol=TCP localport=%APP_PORT% profile=any enable=yes >nul 2>&1
        if errorlevel 1 (
            echo [-] HATA: Firewall kurali eklenemedi: TCP %APP_PORT%
            echo [-] Windows Defender Firewall servisini ve yonetici yetkisini kontrol edin.
            exit /b 1
        )
        echo [+] Firewall kurali eklendi: TCP %APP_PORT%
    ) else (
        echo [+] Firewall kurali zaten mevcut: TCP %APP_PORT%
    )
)

netsh advfirewall firewall show rule name="fg-RustServer - Port %QUERYPORT_FINAL% UDP" >nul 2>&1
if errorlevel 1 (
    netsh advfirewall firewall add rule name="fg-RustServer - Port %QUERYPORT_FINAL% UDP" dir=in action=allow protocol=UDP localport=%QUERYPORT_FINAL% profile=any enable=yes >nul 2>&1
    if errorlevel 1 (
        echo [-] HATA: Firewall kurali eklenemedi: UDP %QUERYPORT_FINAL%
        echo [-] Windows Defender Firewall servisini ve yonetici yetkisini kontrol edin.
        exit /b 1
    )
    echo [+] Firewall kurali eklendi: UDP %QUERYPORT_FINAL% ^(Queryport^)
) else (
    echo [+] Firewall kurali zaten mevcut: UDP %QUERYPORT_FINAL% ^(Queryport^)
)
:FG_FIREWALL_DONE
echo.

:: ========================================================================
:: [11] SERVER.CFG OLUŞTURMA
:: ========================================================================
set "CFG_DIR=%SERVER_DIR%\server\%SERVER_IDENTITY%\cfg"
if not exist "%CFG_DIR%" mkdir "%CFG_DIR%"
set "CFG_FILE=%CFG_DIR%\server.cfg"

echo [*] server.cfg dosyasi olusturuluyor...
echo :: fg-RustServer Otomatik server.cfg > "%CFG_FILE%"
echo server.pve %SERVER_PVE% >> "%CFG_FILE%"
echo server.radiation %SERVER_RADIATION% >> "%CFG_FILE%"
echo relationshipmanager.maxteamsize %SERVER_TEAMMAXSIZE% >> "%CFG_FILE%"
echo server.itemdespawn %SERVER_ITEMDESPAWN% >> "%CFG_FILE%"
if not "%CRAFT_INSTANT%"=="" echo craft.instant %CRAFT_INSTANT% >> "%CFG_FILE%"
echo decay.scale %DECAY_SCALE% >> "%CFG_FILE%"
echo decay.tick %DECAY_TICK% >> "%CFG_FILE%"
echo decay.upkeep %DECAY_UPKEEP% >> "%CFG_FILE%"
echo decay.upkeep_period_minutes %DECAY_UPKEEP_PERIOD_MINUTES% >> "%CFG_FILE%"
echo decay.upkeep_group_scaling %DECAY_UPKEEP_GROUP_SCALING% >> "%CFG_FILE%"
if not "%DECAY_DURATION_TOPTIER%"=="" echo decay.duration_toptier %DECAY_DURATION_TOPTIER% >> "%CFG_FILE%"
if not "%DECAY_DURATION_METAL%"=="" echo decay.duration_metal %DECAY_DURATION_METAL% >> "%CFG_FILE%"
if not "%DECAY_DURATION_STONE%"=="" echo decay.duration_stone %DECAY_DURATION_STONE% >> "%CFG_FILE%"
if not "%DECAY_DURATION_WOOD%"=="" echo decay.duration_wood %DECAY_DURATION_WOOD% >> "%CFG_FILE%"
if not "%DECAY_DURATION_TWIG%"=="" echo decay.duration_twig %DECAY_DURATION_TWIG% >> "%CFG_FILE%"
echo bear.population %BEAR_POPULATION% >> "%CFG_FILE%"
echo boar.population %BOAR_POPULATION% >> "%CFG_FILE%"
echo chicken.population %CHICKEN_POPULATION% >> "%CFG_FILE%"
echo stag.population %STAG_POPULATION% >> "%CFG_FILE%"
echo wolf2.population %WOLF2_POPULATION% >> "%CFG_FILE%"
echo polarbear.population %POLARBEAR_POPULATION% >> "%CFG_FILE%"
echo tiger.population %TIGER_POPULATION% >> "%CFG_FILE%"
echo panther.population %PANTHER_POPULATION% >> "%CFG_FILE%"
echo crocodile.population %CROCODILE_POPULATION% >> "%CFG_FILE%"
echo snakehazard.population %SNAKEHAZARD_POPULATION% >> "%CFG_FILE%"
echo ai.npc_enable %NPCS_ENABLED% >> "%CFG_FILE%"
echo ai.tickrate %AI_TICKRATE% >> "%CFG_FILE%"
echo ai.ignoreplayers %AI_IGNOREPLAYERS% >> "%CFG_FILE%"
if not "%AI_MOVE%"=="" echo ai.move %AI_MOVE% >> "%CFG_FILE%"
if not "%AI_THINK%"=="" echo ai.think %AI_THINK% >> "%CFG_FILE%"
echo cargoship.event_enabled %CARGOSHIP_ENABLED% >> "%CFG_FILE%"
echo cargoship.event_duration_minutes %CARGOSHIP_DURATION_MINUTES% >> "%CFG_FILE%"
echo cargoship.loot_rounds %CARGOSHIP_LOOT_ROUNDS% >> "%CFG_FILE%"
echo cargoship.loot_round_spacing_minutes %CARGOSHIP_LOOT_SPACING_MINUTES% >> "%CFG_FILE%"
if not "%HELI_BULLETDMGSCALE%"=="" echo heli.bulletdamagescale %HELI_BULLETDMGSCALE% >> "%CFG_FILE%"
echo bradley.enabled %BRADLEY_ENABLED% >> "%CFG_FILE%"
echo basemission.missionsenabled %MISSIONS_ENABLED% >> "%CFG_FILE%"
echo codelock.lockoutcooldown %CODELOCK_LOCKOUTCOOLDOWN% >> "%CFG_FILE%"
echo codelock.maxfailedattempts %CODELOCK_MAXFAILEDATTEMPTS% >> "%CFG_FILE%"
if not "%GC_INTERVAL%"=="" echo gc.interval %GC_INTERVAL% >> "%CFG_FILE%"
if not "%GC_BUFFERCOUNT%"=="" echo gc.buffercount %GC_BUFFERCOUNT% >> "%CFG_FILE%"
if not "%ENTITYBATCHSIZE%"=="" echo entitybatchsize %ENTITYBATCHSIZE% >> "%CFG_FILE%"

:: Ekim 2026 "Livestock" guncellemesi anahtarlari
echo vehicle.padrepairsrequired %VEHICLE_PADREPAIRSREQUIRED% >> "%CFG_FILE%"
if not "%VEHICLE_SETREPAIRABLEPADS%"=="" echo vehicle.setrepairablepads %VEHICLE_SETREPAIRABLEPADS% >> "%CFG_FILE%"
if not "%POWERGRID_FUSEDECAYLOWPOP%"=="" echo powergrid.fusedecaylowpop %POWERGRID_FUSEDECAYLOWPOP% >> "%CFG_FILE%"
if not "%POWERGRID_FUSEDECAYHIGHPOP%"=="" echo powergrid.fusedecayhighpop %POWERGRID_FUSEDECAYHIGHPOP% >> "%CFG_FILE%"
if not "%POWERGRID_FUSEDECAYLOWPOPSCALE%"=="" echo powergrid.fusedecaylowpopscale %POWERGRID_FUSEDECAYLOWPOPSCALE% >> "%CFG_FILE%"
if not "%SERVER_UPGRADE_KEEPS_HEALTH%"=="" echo server.upgrade_keeps_health %SERVER_UPGRADE_KEEPS_HEALTH% >> "%CFG_FILE%"
if not "%COW_POPULATION%"=="" echo cow.population %COW_POPULATION% >> "%CFG_FILE%"
if not "%SHEEP_POPULATION%"=="" echo sheep.population %SHEEP_POPULATION% >> "%CFG_FILE%"

:: Owner (Sahip) yetkilerini ekleme
if not "!SERVER_OWNERS!"=="" (
    for %%O in (!SERVER_OWNERS!) do (
        echo ownerid %%O >> "%CFG_FILE%"
    )
)

:: Moderator yetkilerini ekleme
if not "!SERVER_MODERATORS!"=="" (
    for %%M in (!SERVER_MODERATORS!) do (
        echo moderatorid %%M >> "%CFG_FILE%"
    )
)

echo [+] server.cfg basariyla yazildi.
echo.

:: ========================================================================
:: [12] SUNUCU BAŞLATMA DÖNGÜSÜ
:: ========================================================================
set "CRASH_COUNT=0"

:: Random Seed Hesaplama
if "%SERVER_SEED%"=="auto" (
    set /a SEED_VALUE=%RANDOM% * 65537
) else (
    set "SEED_VALUE=%SERVER_SEED%"
)

:: Parametreleri Hazirlama
set "START_PARAMS=-batchmode -nographics -silent-crashes"
:: Ekim 2026: yeni navmesh varsayilan. Yalnizca eski navmesh istenirse parametre eklenir.
if "%SERVER_OLD_NAVMESH%"=="1" set "START_PARAMS=!START_PARAMS! -useOldNavmesh"
set "START_PARAMS=!START_PARAMS! +server.ip !SERVER_IP! +server.port !SERVER_PORT!"
set "START_PARAMS=!START_PARAMS! +server.identity "!SERVER_IDENTITY!""
set "START_PARAMS=!START_PARAMS! +server.hostname "!SERVER_HOSTNAME!""
set "START_PARAMS=!START_PARAMS! +server.description "!SERVER_DESCRIPTION!""
set "START_PARAMS=!START_PARAMS! +server.url "!SERVER_URL!""
set "START_PARAMS=!START_PARAMS! +server.headerimage "!SERVER_HEADERIMAGE!""
if not "!SERVER_LOGOIMAGE!"=="" set "START_PARAMS=!START_PARAMS! +server.logoimage "!SERVER_LOGOIMAGE!""
set "START_PARAMS=!START_PARAMS! +server.maxplayers !SERVER_MAXPLAYERS!"

if "!SERVER_LEVELURL!"=="" (
    set "START_PARAMS=!START_PARAMS! +server.seed !SEED_VALUE! +server.worldsize !SERVER_WORLDSIZE! +server.level "!SERVER_LEVEL!""
) else (
    set "START_PARAMS=!START_PARAMS! +server.levelurl "!SERVER_LEVELURL!""
)

set "START_PARAMS=!START_PARAMS! +server.saveinterval !SERVER_SAVEINTERVAL! +server.tickrate !SERVER_TICKRATE!"
set "START_PARAMS=!START_PARAMS! +server.secure !SERVER_SECURE! +server.eac !SERVER_EAC! +server.encryption !SERVER_ENCRYPTION! +server.stability !SERVER_STABILITY!"
set "START_PARAMS=!START_PARAMS! +server.tags "!SERVER_TAGS!""
set "START_PARAMS=!START_PARAMS! +rcon.ip !RCON_IP! +rcon.port !RCON_PORT! +rcon.password "!RCON_PASSWORD!" +rcon.web !RCON_WEB!"

if "!RUSTPLUS_ENABLED!"=="1" (
    set "START_PARAMS=!START_PARAMS! +app.port !APP_PORT!"
    if not "!APP_LISTENIP!"=="" set "START_PARAMS=!START_PARAMS! +app.listenip !APP_LISTENIP!"
    if not "!APP_PUBLICIP!"=="" set "START_PARAMS=!START_PARAMS! +app.publicip !APP_PUBLICIP!"
) else (
    set "START_PARAMS=!START_PARAMS! +app.port 1-"
)

set "START_PARAMS=!START_PARAMS! +server.queryport !QUERYPORT_FINAL!"
if not "!SERVER_FPSLIMIT!"=="" set "START_PARAMS=!START_PARAMS! +fps.limit !SERVER_FPSLIMIT!"
set "START_PARAMS=!START_PARAMS! +global.maxthreads !GLOBAL_MAXTHREADS!"

if "%FG_DRY_RUN%"=="1" (
    echo ===================================================
    echo   KURU CALISTIRMA OZETI ^(FG_DRY_RUN=1^)
    echo ===================================================
    echo [*] Uretilen server.cfg: !CFG_FILE!
    echo ---------------------------------------------------
    if exist "!CFG_FILE!" type "!CFG_FILE!"
    echo ---------------------------------------------------
    echo [*] Kullanilacak baslatma parametreleri:
    echo RustDedicated.exe !START_PARAMS!
    echo ===================================================
    echo [*] Kuru calistirma tamamlandi: kurulum, firewall veya sunucu islemi yapilmadi.
    exit /b 0
)

:START_SERVER
:: Log dosyasini tarih-saat formatli isimlendirme (locale-bagimsiz)
:: 1) PowerShell, 2) wmic yedegi (eski sistemler), 3) %DATE%/%TIME% son care
set "DT="
set "DT_TS="
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "Get-Date -Format 'yyyyMMddHHmm'"`) do set "DT=%%a"
if not defined DT for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value 2^>nul') do set "DT=%%a"
if defined DT set "DT_TS=!DT:~0,4!-!DT:~4,2!-!DT:~6,2!_!DT:~8,2!!DT:~10,2!"
if not defined DT_TS (
    set "DT_TS=%DATE%_%TIME%"
    set "DT_TS=!DT_TS:/=-!"
    set "DT_TS=!DT_TS::=-!"
    set "DT_TS=!DT_TS: =_!"
)
set "LOG_FILE=%LOG_DIR%\server_!DT_TS!.log"
set "START_PARAMS_FULL=!START_PARAMS! -logfile "!LOG_FILE!""

:: Uptime takibi: crash sayacini sifirlamak icin baslangic zamani (epoch saniye)
set "FG_START_EPOCH="
set "FG_END_EPOCH="
if "%CRASH_RESTART%"=="1" for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[int](New-TimeSpan -Start (Get-Date '1970-01-01') -End (Get-Date)).TotalSeconds"`) do set "FG_START_EPOCH=%%a"

echo [*] Sunucu baslatiliyor... (%CRASH_COUNT% / %MAX_CRASH_RESTARTS% crash denemesi)
cd /d "%SERVER_DIR%"

if not exist "%SERVER_DIR%\RustDedicated.exe" (
    echo [-] HATA: RustDedicated.exe bulunamadi. SteamCMD kurulumu basarisiz olmus olabilir.
    echo [-] Lutfen internet baglantinizi ve SERVER_BRANCH ayarini kontrol edin.
    pause
    exit /b 1
)

setlocal DisableDelayedExpansion
RustDedicated.exe %START_PARAMS_FULL%
endlocal

echo.
echo [-] Sunucu kapandi.

:: Uptime olcumu: sunucu esik sureden uzun ayakta kaldiysa crash sayaci sifirlanir
if defined FG_START_EPOCH for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[int](New-TimeSpan -Start (Get-Date '1970-01-01') -End (Get-Date)).TotalSeconds"`) do set "FG_END_EPOCH=%%a"
set "FG_RUNTIME=0"
if defined FG_END_EPOCH set /a FG_RUNTIME=FG_END_EPOCH-FG_START_EPOCH
if !FG_RUNTIME! geq %CRASH_RESET_UPTIME_SECONDS% (
    echo [*] Sunucu !FG_RUNTIME! saniye kesintisiz ayakta kaldi. Crash sayaci sifirlandi.
    set "CRASH_COUNT=0"
)

if "%CRASH_RESTART%"=="1" (
    set /a CRASH_COUNT+=1
    if !CRASH_COUNT! leq %MAX_CRASH_RESTARTS% (
        echo [*] Sunucunun cöktugu algilandi. %CRASH_WAIT_SECONDS% saniye icinde yeniden baslatiliyor...
        timeout /t %CRASH_WAIT_SECONDS% /nobreak
        goto START_SERVER
    ) else (
        echo [-] Maksimum crash yeniden baslatma sayisina ulasildi. Lutfen loglari kontrol edin.
        pause
    )
)

echo.
echo [*] Script sonlandiriliyor...
pause
