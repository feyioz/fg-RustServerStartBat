@echo off
setlocal EnableDelayedExpansion

if /I "%~1"=="__FG_RUN__" goto MAIN
"%ComSpec%" /v:on /c call "%~f0" __FG_RUN__
set "FG_EXIT_CODE=!ERRORLEVEL!"
echo.
if not "!FG_EXIT_CODE!"=="0" (
    echo [!] Script hata kodu !FG_EXIT_CODE! ile durdu. Yukaridaki hata mesajlarini kontrol edin.
)
echo [*] Konsol penceresi otomatik kapanmayacak.
pause
exit /b !FG_EXIT_CODE!

:MAIN

:: ========================================================================
:: fg-RustServerStart.BAT
:: Tam Otomatik Rust Dedicated Server Scripti
:: Versiyon: 1.4.10
:: ========================================================================

:: ========================================================================
:: [1] KULLANICI YAPILANDIRMA BÖLÜMÜ
:: ========================================================================

:: --- 1.1 Sunucu Temel Ayarları ---
set "SERVER_HOSTNAME=feyioz Rust Server"
set "SERVER_DESCRIPTION=Powered by feyioz - Tam otomatik sunucu"
set "SERVER_URL=https://feyioz.com"
set "SERVER_HEADERIMAGE=https://feyioz.com/banner.jpg"
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
set "DECAY_DURATION_TOPTIER="
set "DECAY_DURATION_METAL="
set "DECAY_DURATION_STONE="
set "DECAY_DURATION_WOOD="
set "DECAY_DURATION_TWIG="

:: --- 1.7 Hayvan & NPC Popülasyon Ayarları ---
set "BEAR_POPULATION=2"
set "BOAR_POPULATION=5"
set "CHICKEN_POPULATION=3"
set "STAG_POPULATION=3"
set "WOLF_POPULATION=3"
set "AI_TICKRATE=5"
set "AI_IGNOREPLAYERS=0"

:: --- 1.8 Oyun İçi Event Ayarları ---
set "CARGOSHIP_ENABLED=1"
set "CARGOSHIP_DURATION_MINUTES=50"
set "CARGOSHIP_LOOT_ROUNDS=3"
set "CARGOSHIP_LOOT_SPACING_MINUTES=10"
set "PATROLHELICOPTER_MAX=1"
set "HELI_BULLETDAMAGE="
set "BRADLEY_ENABLED=1"
set "MISSIONS_ENABLED=1"

:: --- 1.9 Oynanış & Gelişmiş Ayarları ---
set "SERVER_PVE=0"
set "CRAFT_INSTANT=0"
set "SERVER_ITEMDESPAWN=180"
set "SERVER_BRANCH=public"

:: --- 1.10 Dizin & Güncelleme Ayarları ---
set "STEAMCMD_DIR=%~dp0steamcmd"
set "SERVER_DIR=%~dp0server"
set "LOG_DIR=%~dp0logs"
set "AUTO_UPDATE=1"
set "ENABLE_UMOD=0"

:: --- 1.11 Crash & Yeniden Başlatma Ayarları ---
set "CRASH_RESTART=1"
set "CRASH_WAIT_SECONDS=30"
set "MAX_CRASH_RESTARTS=5"

:: --- 1.12 Yönetici & Yetki Ayarları ---
:: Birden fazla Steam64ID eklemek için virgülle ayırın. Örnek: "76561198000000001,76561198000000002"
set "SERVER_OWNERS="
set "SERVER_MODERATORS="

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
:: [3] YÖNETİCİ YETKİ KONTROLÜ
:: ========================================================================
echo [*] Yonetici yetkileri kontrol ediliyor...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [+] Yonetici yetkileri basariyla dogrulandi.
) else (
    echo [-] Yonetici yetkisi bulunamadi! UAC istegi gonderiliyor...
    powershell -Command "Start-Process cmd -ArgumentList '/k \"\"%~dpnx0\"\"' -Verb RunAs"
    exit /b
)
echo.

:: ========================================================================
:: [4] WINDOWS SERVER 2022 OPTİMİZASYONLARI
:: ========================================================================
echo [*] Windows Server 2022 / Performans optimizasyonlari uygulaniyor...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [+] Guc plani 'Yuksek Performans' olarak ayarlandi.
echo.

:: ========================================================================
:: [5] DİZİN YAPISININ OLUŞTURULMASI
:: ========================================================================
echo [*] Dizin yapisi kontrol ediliyor...
if not exist "%STEAMCMD_DIR%" mkdir "%STEAMCMD_DIR%"
if not exist "%SERVER_DIR%" mkdir "%SERVER_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
echo [+] Dizinler hazir.
echo.

:: ========================================================================
:: [6] STEAMCMD KONTROLÜ VE KURULUMU
:: ========================================================================
if not exist "%STEAMCMD_DIR%\steamcmd.exe" (
    echo [*] SteamCMD bulunamadi. İndiriliyor...
    powershell -Command "Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile '%STEAMCMD_DIR%\steamcmd.zip'"
    echo [*] SteamCMD arsivden cikariliyor...
    powershell -Command "Expand-Archive -Path '%STEAMCMD_DIR%\steamcmd.zip' -DestinationPath '%STEAMCMD_DIR%' -Force"
    del "%STEAMCMD_DIR%\steamcmd.zip"
    echo [+] SteamCMD kurulumu tamamlandi.
) else (
    echo [+] SteamCMD zaten kurulu.
)
echo.

:: ========================================================================
:: [7] RUST SERVER KURULUMU/GÜNCELLEMESİ
:: ========================================================================
if "%AUTO_UPDATE%"=="1" (
    echo [*] Rust Dedicated Server guncelleniyor/kuruluyor...
    set "STEAMCMD_SUCCESS=0"
    for /L %%i in (1,1,3) do (
        if "!STEAMCMD_SUCCESS!"=="0" (
            if /I "%SERVER_BRANCH%"=="public" (
                "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 258550 validate +quit
            ) else (
                "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update 258550 -beta %SERVER_BRANCH% validate +quit
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
echo.

:: ========================================================================
:: [8] UMOD/OXIDE KURULUMU (Opsiyonel)
:: ========================================================================
if "%ENABLE_UMOD%"=="1" (
    echo [*] uMod/Oxide surumleri kontrol ediliyor...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/OxideMod/Oxide.Rust/releases' | Select-Object -First 5; Write-Host '==================================================='; Write-Host '       uMod/Oxide Kurulum Menusu'; Write-Host '==================================================='; $i = 1; foreach ($r in $releases) { Write-Host ('[' + $i + '] ' + $r.tag_name); $i++ }; Write-Host '[0] Iptal et / Atla'; Write-Host '==================================================='; $selection = -1; while ($true) { $input = Read-Host 'Lutfen kurmak istediginiz surumu secin (0-5)'; if ([int]::TryParse($input, [ref]$selection) -and $selection -ge 0 -and $selection -le 5) { break; } else { Write-Host '[-] Gecersiz secim. Lutfen 0 ile 5 arasinda bir sayi girin.' -ForegroundColor Red } }; if ($selection -eq 0) { Write-Host '[*] uMod kurulumu atlandi.' -ForegroundColor Yellow; exit 0 }; $selectedRelease = $releases[$selection - 1]; $version = $selectedRelease.tag_name; $asset = $selectedRelease.assets | Where-Object { $_.name -eq 'Oxide.Rust.zip' }; if (-not $asset) { Write-Host '[-] HATA: Secilen surum icin Oxide.Rust.zip bulunamadi.' -ForegroundColor Red; exit 1 }; $zipFile = '%SERVER_DIR%\Oxide.Rust.zip'; Write-Host ('[*] ' + $version + ' indiriliyor...') -ForegroundColor Cyan; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipFile; Write-Host '[*] uMod dosyalari arsivden cikariliyor...' -ForegroundColor Cyan; Add-Type -AssemblyName System.IO.Compression.FileSystem; $archive = [System.IO.Compression.ZipFile]::OpenRead($zipFile); foreach ($entry in $archive.Entries) { $destinationPath = [System.IO.Path]::Combine('%SERVER_DIR%', $entry.FullName); $destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath); if (-not (Test-Path $destinationDir)) { New-Item -ItemType Directory -Path $destinationDir | Out-Null }; if ($entry.Name -ne '') { try { if (Test-Path $destinationPath) { Set-ItemProperty -Path $destinationPath -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue; Remove-Item -Path $destinationPath -Force -ErrorAction Stop }; [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destinationPath, $true) } catch { Write-Host ('[-] HATA: ' + $destinationPath + ' yazilamadi. ' + $_.Exception.Message) -ForegroundColor Red; exit 1 } } }; $archive.Dispose(); $checkFile = [System.IO.Path]::Combine('%SERVER_DIR%', 'RustDedicated_Data', 'Managed', 'Oxide.Core.dll'); if (-not (Test-Path $checkFile)) { Write-Host '[-] HATA: Oxide dosyalari eksik.' -ForegroundColor Red; exit 1 } else { Write-Host ('[+] uMod kurulumu (' + $version + ') basariyla tamamlandi.') -ForegroundColor Green }"
    if !errorlevel! neq 0 (
        echo [-] UYARI: uMod/Oxide kurulumunda kritik bir hata olustu! Lutfen yukaridaki kirmizi mesajlari kontrol edin.
        pause
        exit /b 1
    )
) else (
    echo [*] uMod/Oxide kurulumu devre disi.
)
echo.

:: ========================================================================
:: [9] FIREWALL KURALLARI
:: ========================================================================
echo [*] Windows Firewall kurallari kontrol ediliyor...
netsh advfirewall firewall show rule name="fg-RustServer - Port %SERVER_PORT% UDP" >nul 2>&1
if errorlevel 1 (
    netsh advfirewall firewall add rule name="fg-RustServer - Port %SERVER_PORT% UDP" dir=in action=allow protocol=UDP localport=%SERVER_PORT% >nul 2>&1
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
    netsh advfirewall firewall add rule name="fg-RustServer - Port %RCON_PORT% TCP" dir=in action=allow protocol=TCP localport=%RCON_PORT% >nul 2>&1
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
        netsh advfirewall firewall add rule name="fg-RustServer - Port %APP_PORT% TCP" dir=in action=allow protocol=TCP localport=%APP_PORT% >nul 2>&1
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

if not "%SERVER_QUERYPORT%"=="" (
    netsh advfirewall firewall show rule name="fg-RustServer - Port %SERVER_QUERYPORT% UDP" >nul 2>&1
    if errorlevel 1 (
        netsh advfirewall firewall add rule name="fg-RustServer - Port %SERVER_QUERYPORT% UDP" dir=in action=allow protocol=UDP localport=%SERVER_QUERYPORT% >nul 2>&1
        if errorlevel 1 (
            echo [-] HATA: Firewall kurali eklenemedi: UDP %SERVER_QUERYPORT%
            echo [-] Windows Defender Firewall servisini ve yonetici yetkisini kontrol edin.
            exit /b 1
        )
        echo [+] Firewall kurali eklendi: UDP %SERVER_QUERYPORT%
    ) else (
        echo [+] Firewall kurali zaten mevcut: UDP %SERVER_QUERYPORT%
    )
)
echo.

:: ========================================================================
:: [10] SERVER.CFG OLUŞTURMA
:: ========================================================================
set "CFG_DIR=%SERVER_DIR%\server\%SERVER_IDENTITY%\cfg"
if not exist "%CFG_DIR%" mkdir "%CFG_DIR%"
set "CFG_FILE=%CFG_DIR%\server.cfg"

echo [*] server.cfg dosyasi olusturuluyor...
echo :: fg-RustServer Otomatik server.cfg > "%CFG_FILE%"
echo server.pve %SERVER_PVE% >> "%CFG_FILE%"
echo craft.instant %CRAFT_INSTANT% >> "%CFG_FILE%"
echo server.itemdespawn %SERVER_ITEMDESPAWN% >> "%CFG_FILE%"
echo decay.scale %DECAY_SCALE% >> "%CFG_FILE%"
echo decay.tick %DECAY_TICK% >> "%CFG_FILE%"
echo decay.upkeep %DECAY_UPKEEP% >> "%CFG_FILE%"
echo decay.upkeep_period_minutes %DECAY_UPKEEP_PERIOD_MINUTES% >> "%CFG_FILE%"
if not "%DECAY_DURATION_TOPTIER%"=="" echo decay.duration_toptier %DECAY_DURATION_TOPTIER% >> "%CFG_FILE%"
if not "%DECAY_DURATION_METAL%"=="" echo decay.duration_metal %DECAY_DURATION_METAL% >> "%CFG_FILE%"
if not "%DECAY_DURATION_STONE%"=="" echo decay.duration_stone %DECAY_DURATION_STONE% >> "%CFG_FILE%"
if not "%DECAY_DURATION_WOOD%"=="" echo decay.duration_wood %DECAY_DURATION_WOOD% >> "%CFG_FILE%"
if not "%DECAY_DURATION_TWIG%"=="" echo decay.duration_twig %DECAY_DURATION_TWIG% >> "%CFG_FILE%"
echo bear.population %BEAR_POPULATION% >> "%CFG_FILE%"
echo boar.population %BOAR_POPULATION% >> "%CFG_FILE%"
echo chicken.population %CHICKEN_POPULATION% >> "%CFG_FILE%"
echo stag.population %STAG_POPULATION% >> "%CFG_FILE%"
echo wolf.population %WOLF_POPULATION% >> "%CFG_FILE%"
echo ai.tickrate %AI_TICKRATE% >> "%CFG_FILE%"
echo ai.ignoreplayers %AI_IGNOREPLAYERS% >> "%CFG_FILE%"
echo cargoship.event_enabled %CARGOSHIP_ENABLED% >> "%CFG_FILE%"
echo cargoship.event_duration_minutes %CARGOSHIP_DURATION_MINUTES% >> "%CFG_FILE%"
echo cargoship.loot_rounds %CARGOSHIP_LOOT_ROUNDS% >> "%CFG_FILE%"
echo cargoship.loot_spacing_minutes %CARGOSHIP_LOOT_SPACING_MINUTES% >> "%CFG_FILE%"
echo patrolhelicopter.max %PATROLHELICOPTER_MAX% >> "%CFG_FILE%"
if not "%HELI_BULLETDAMAGE%"=="" echo heli.bulletdamage %HELI_BULLETDAMAGE% >> "%CFG_FILE%"
echo bradley.enabled %BRADLEY_ENABLED% >> "%CFG_FILE%"
echo basemission.missionsenabled %MISSIONS_ENABLED% >> "%CFG_FILE%"
echo codelock.lockoutcooldown %CODELOCK_LOCKOUTCOOLDOWN% >> "%CFG_FILE%"
echo codelock.maxfailedattempts %CODELOCK_MAXFAILEDATTEMPTS% >> "%CFG_FILE%"
if not "%GC_INTERVAL%"=="" echo gc.interval %GC_INTERVAL% >> "%CFG_FILE%"
if not "%GC_BUFFERCOUNT%"=="" echo gc.buffercount %GC_BUFFERCOUNT% >> "%CFG_FILE%"
if not "%ENTITYBATCHSIZE%"=="" echo entitybatchsize %ENTITYBATCHSIZE% >> "%CFG_FILE%"

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
:: [11] SUNUCU BAŞLATMA DÖNGÜSÜ
:: ========================================================================
set CRASH_COUNT=0

:: Random Seed Hesaplama
if "%SERVER_SEED%"=="auto" (
    set /a SEED_VALUE=%RANDOM% * 65537
) else (
    set "SEED_VALUE=%SERVER_SEED%"
)

:: Parametreleri Hazirlama
set "START_PARAMS=-batchmode -nographics -silent-crashes"
set "START_PARAMS=!START_PARAMS! +server.ip !SERVER_IP! +server.port !SERVER_PORT!"
set "START_PARAMS=!START_PARAMS! +server.identity "!SERVER_IDENTITY!""
set "START_PARAMS=!START_PARAMS! +server.hostname "!SERVER_HOSTNAME!""
set "START_PARAMS=!START_PARAMS! +server.description "!SERVER_DESCRIPTION!""
set "START_PARAMS=!START_PARAMS! +server.url "!SERVER_URL!""
set "START_PARAMS=!START_PARAMS! +server.headerimage "!SERVER_HEADERIMAGE!""
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

if not "!SERVER_QUERYPORT!"=="" set "START_PARAMS=!START_PARAMS! +server.queryport !SERVER_QUERYPORT!"
if not "!SERVER_FPSLIMIT!"=="" set "START_PARAMS=!START_PARAMS! +server.fps !SERVER_FPSLIMIT!"
set "START_PARAMS=!START_PARAMS! +global.maxthreads !GLOBAL_MAXTHREADS!"

:START_SERVER
:: Log dosyasini tarih-saat formatli isimlendirme (locale-bagimsiz)
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value 2^>nul') do set "DT=%%a"
set "LOG_FILE=%LOG_DIR%\server_%DT:~0,4%-%DT:~4,2%-%DT:~6,2%_%DT:~8,2%%DT:~10,2%.log"
set "START_PARAMS_FULL=!START_PARAMS! -logfile "!LOG_FILE!""

echo [*] Sunucu baslatiliyor... (%CRASH_COUNT% / %MAX_CRASH_RESTARTS% crash denemesi)
cd /d "%SERVER_DIR%"

if not exist "%SERVER_DIR%\RustDedicated.exe" (
    echo [-] HATA: RustDedicated.exe bulunamadi! SteamCMD kurulumu basarisiz olmus olabilir.
    echo [-] Lutfen internet baglantinizi ve SERVER_BRANCH ayarini kontrol edin.
    pause
    exit /b 1
)

setlocal DisableDelayedExpansion
RustDedicated.exe %START_PARAMS_FULL%
endlocal

echo.
echo [!] Sunucu kapandi.
if "%CRASH_RESTART%"=="1" (
    set /a CRASH_COUNT+=1
    if !CRASH_COUNT! leq %MAX_CRASH_RESTARTS% (
        echo [*] Sunucunun cöktugu algilandi. %CRASH_WAIT_SECONDS% saniye icinde yeniden baslatiliyor...
        timeout /t %CRASH_WAIT_SECONDS% /nobreak
        goto START_SERVER
    ) else (
        echo [-] Maksimum crash yeniden baslatma sayisina ulasildi! Lutfen loglari kontrol edin.
        pause
    )
)

echo.
echo [*] Script sonlandiriliyor...
pause
