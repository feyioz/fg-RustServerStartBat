# 🎮 fg-RustServerStart.BAT - Tam Otomatik Rust Sunucu Scripti

[![Version](https://img.shields.io/badge/version-1.5.0-blue.svg)](https://github.com/feyioz/fg-RustServerStartBat)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

SteamCMD kullanarak Rust dedicated server'ı otomatik indiren, yükleyen, güncelleyen ve **50'den fazla parametre** ile başlatan en kapsamlı tam otomatik batch scriptidir. Sadece çalıştırın, arkanıza yaslanın! 🎉

---

## 📜 Proje Kuralları

Bu projenin geliştirilmesinde aşağıdaki standartlara ve kılavuzlara uyulmaktadır:

1. **Tam Otomasyon:** Script, kullanıcı müdahalesi olmadan gerekli araçları (SteamCMD, uMod, Rust DS) indirebilir, klasör yapısını kurabilir ve güncelleyebilir olmalıdır.
2. **Kapsamlı Yapılandırma:** Script içindeki değişkenler, kullanıcıların her türlü sunucu ayarını (Performans, Ağ, Decay, Popülasyon vb.) dışarıdan ek bir dosyaya ihtiyaç duymadan değiştirebilmesine olanak tanımalıdır.
3. **Güvenlik ve İzolasyon:** Script Windows Güvenlik Duvarı kurallarını otomatik yönetmeli ve gerekli izinler olmadığında UAC isteği ile güvenli bir yükseltme yapmalıdır.
4. **Hata Toleransı (Resilience):** Crash durumlarında sunucu otomatik olarak yeniden başlatılmalı; ancak sonsuz döngüleri önlemek için bir sınır (limit) belirlenmelidir.
5. **Dokümantasyon Sürekliliği:** Her sürüm güncellemesinde `README.md` dosyası projenin kök dizininde otomatik güncellenmeli ve sürüm numarası artırılmalıdır.
6. **AGENTS.md Dokunulmazlığı:** Projenin kök dizinindeki `AGENTS.md` dosyası salt okunur referans kabul edilir; üzerinde herhangi bir düzenleme, silme veya güncelleme yapılmaz.
7. **Web Araması Kuralı:** Güncel ve olgusal doğruluk gerektiren sorgularda, iç bilgi tabanına başvurulmadan önce her zaman önce Web Araması (Web Search) çalıştırılır.
8. **İşletim Sistemi Uyumu:** Geliştirme, script'in Windows Server 2022 Standard üzerinde hatasız çalışması hedefiyle yapılır; her değişiklik bu ortam açısından uyumluluk bakımından değerlendirilir.
9. **Kaynak Verimliliği:** Yanıt kalitesinden ve doğruluktan ödün vermeden token, bağlam ve kaynak tasarrufu hedeflenir; öz ve amaca yönelik çıktılar üretilir.

---

## 🛠️ Teknolojiler

Bu projede kullanılan ana kütüphane, framework ve araçlar:

- **Windows Batch Scripting (`.bat`)**: Ana otomasyon ve yürütme döngüsü.
- **PowerShell**: Web üzerinden dosya indirme (`Invoke-WebRequest`), arşiv çıkarma (`Expand-Archive`) ve UAC ayrıcalık yükseltme işlemleri için.
- **SteamCMD**: Valve'in komut satırı tabanlı oyun sunucusu indirme/güncelleme aracı.
- **Rust Dedicated Server**: Facepunch Studios'un sağladığı orijinal sunucu altyapısı (App ID: `258550`).
- **uMod (Oxide)**: Rust sunucularını modlamak için kullanılan popüler eklenti altyapısı.

---

## 💻 Kurulum

### 📋 Sistem Gereksinimleri

| Bileşen | Minimum | Önerilen |
|---------|---------|----------|
| **İşletim Sistemi** | Windows 10 / Server 2016 | Windows 11 / Server 2022 |
| **İşlemci (CPU)** | 4 Çekirdek (3.0 GHz+) | 8+ Çekirdek (Yüksek Saat Hızı) |
| **Bellek (RAM)** | 12 GB | 16 GB+ (Harita boyutuna bağlı) |
| **Depolama** | 30 GB Boş Alan (SSD) | 50 GB+ NVMe M.2 SSD |
| **Ağ** | Genişbant İnternet | 1 Gbps / Statik IP / DDoS Koruması |

> 📌 **Windows Server 2022 Uyumluluğu:** Script, özellikle Windows Server 2022 üzerinde çalışacak şekilde optimize edilmiştir. Çalıştırıldığı zaman oyun sunucusundan maksimum verim almak için işletim sisteminin güç planını otomatik olarak **Yüksek Performans** (High Performance) olarak ayarlar.

### 🚀 Adım Adım Kurulum

1. Bu projeyi bilgisayarınıza indirin veya `git clone` ile kopyalayın:
   ```bash
   git clone https://github.com/feyioz/fg-RustServerStartBat.git
   ```
2. İndirdiğiniz klasörün içerisine girin.
3. Herhangi bir ek kurulum yapmanıza gerek yoktur, `fg-RustServerStart.BAT` tüm indirme ve kurulum işlemlerini kendi başına yapacaktır.

---

## ⚙️ Yapılandırma ve Parametreler

`fg-RustServerStart.BAT` dosyasını herhangi bir metin editörü (Notepad, VS Code vb.) ile açın. En üst kısımda **[1] KULLANICI YAPILANDIRMA BÖLÜMÜ** altında aşağıdaki tüm parametreleri görebilirsiniz. Kendi sunucunuza uygun şekilde değiştirebilirsiniz.

### 1.1 Sunucu Temel Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `SERVER_HOSTNAME` | "feyioz Rust Server" | Sunucunun oyun içinde görünen adı. |
| `SERVER_DESCRIPTION` | "Powered by feyioz - Tam otomatik sunucu" | Sunucu açıklaması. (\n ile alt satıra geçilebilir) |
| `SERVER_URL` | "https://feyioz.com" | Sunucunun web sitesi veya Discord linki. |
| `SERVER_HEADERIMAGE` | "https://feyioz.com/banner.jpg" | Sunucu banner resmi. (512x256 önerilir) |
| `SERVER_LOGOIMAGE` | "" | Sunucu logosu. (Sunucu tarayıcısında ve Rust+ uygulamasında gösterilir. Boş bırakılırsa gönderilmez) |
| `SERVER_IDENTITY` | "feyioz_rust" | Kayıt dosyalarının ve ayarların tutulduğu klasör adı. |
| `SERVER_MAXPLAYERS` | 50 | Maksimum oyuncu sayısı. |
| `SERVER_SEED` | "auto" | Harita tohumu. (0-2147483647 arası sayı. "auto" rastgele oluşturur) |
| `SERVER_WORLDSIZE` | 4000 | Harita boyutu. (1000-6000 arası) |
| `SERVER_LEVEL` | "Procedural Map" | Harita türü. (Procedural Map, Barren, SavasIsland vb.) |
| `SERVER_LEVELURL` | "" | Özel (Custom) harita kullanılacaksa .map dosyasının URL'si. |
| `SERVER_TAGS` | "monthly,vanilla,EU" | Sunucu etiketleri. Oyun içi aramada çıkmayı sağlar. (Maks. 4 tag, virgülle ayrılır) |

<details>
<summary><strong>🏷️ SERVER_TAGS - Tüm Kullanılabilir Etiketler Listesi</strong></summary>

Tags, Rust sunucu tarayıcısında oyuncuların sunucunuzu bulmasını sağlayan ek bilgi parçalarıdır. Sunucu tarayıcısında aynı anda en fazla **4 tag** görüntülenir.

> **Örnek Kullanım:** `SERVER_TAGS` değişkenine değer olarak tag'lerin **Value** (değer) sütunundaki isimleri virgülle ayırarak yazın.
> Örnek: `"monthly,vanilla,roleplay,EU"`

---

#### 🗓️ Wipe Sıklığı Tag'leri (Grup - sadece 1 tanesi seçilebilir)

| Value | Görünen Ad | Açıklama |
|-------|------------|----------|
| `monthly` | Monthly | Ayda bir wipe yapılan sunucular için. |
| `biweekly` | Biweekly | İki haftada bir wipe yapılan sunucular için. |
| `weekly` | Weekly | Haftada bir wipe yapılan sunucular için. |

#### ⚔️ Zorluk Tag'leri (Grup - sadece 1 tanesi seçilebilir)

| Value | Görünen Ad | Açıklama |
|-------|------------|----------|
| `vanilla` | Vanilla | Eklenti (plugin) kullanılmayan, varsayılan ayarlarda oynanan sunucular. |
| `hardcore` | Hardcore | Hardcore oyun modu aktif sunucular. |
| `softcore` | Softcore | Softcore oyun modu aktif sunucular. Daha kolay oynanış, güvenli bölge vb. |

#### 🌍 Bölge Tag'leri (Grup - sadece 1 tanesi seçilebilir)

| Value | Görünen Ad | Açıklama |
|-------|------------|----------|
| `NA` | North America | Kuzey Amerika bölgesi. |
| `SA` | South America | Güney Amerika bölgesi. |
| `EU` | Europe | Avrupa bölgesi. |
| `WA` | West Asia | Batı Asya / Orta Doğu bölgesi. |
| `EA` | East Asia | Doğu Asya bölgesi. |
| `OC` | Oceania | Avustralya ve Okyanusya bölgesi. |
| `AF` | Africa | Afrika bölgesi. |

#### 🎮 Oynanış Tag'leri (Grupsuz - istediğiniz kadar seçebilirsiniz)

| Value | Görünen Ad | Açıklama |
|-------|------------|----------|
| `pve` | PvE | Oyuncular birbirine hasar veremez. Sadece çevre ve NPC'lere karşı oynanır. |
| `roleplay` | Roleplay | Rol yapma odaklı özel tasarlanmış sunucular. |
| `creative` | Creative | Hayatta kalma özellikleri kapalı, serbest yapım sunucuları. |
| `minigame` | Minigame | Özel ve benzersiz oyun modları sunan sunucular. |
| `training` | Combat Training | Nişancılık ve savaş eğitimi için tasarlanmış sunucular. |
| `battlefield` | Battlefield | PVP odaklı modlu sunucular. |
| `broyale` | Battle Royale | Son adam kalan kazanır tarzı battle-royale sunucuları. |
| `builds` | Build Server | Sadece üs (base) yapımına ayrılmış özel sunucular. |
| `tut` | Tutorial | Yeni oyuncular için eğitim amaçlı sunucular. |
| `premium` | Premium | Ücretli/premium özellikler sunan sunucular. |

#### 🔧 Modlama Framework Tag'leri (Otomatik atanır)

| Görünen Ad | Açıklama |
|------------|----------|
| Modded | Sunucuda herhangi bir modlama varsa otomatik atanır. |
| Oxide | uMod/Oxide framework kuruluysa otomatik atanır. |
| Carbon | Carbon framework kuruluysa otomatik atanır. |

> ⚠️ **Önemli Notlar:**
> - Her gruptan (Wipe Sıklığı, Zorluk, Bölge) **sadece 1 tag** seçebilirsiniz. Aynı gruptan birden fazla seçmek çakışmaya neden olur.
> - Oynanış tag'lerinde böyle bir kısıtlama yoktur, birden fazla seçebilirsiniz.
> - Modlama framework tag'leri (`Modded`, `Oxide`, `Carbon`) otomatik atanır, manuel eklemenize gerek yoktur.
> - Eğer uMod/Oxide kullanıyorsanız sunucunuz otomatik olarak "modded" kategorisinde listelenir; `vanilla` tag'i artık gösterilmez.
> - Maksimum **4 tag** sunucu tarayıcısında görünür.
> - Kaynak: [Facepunch Resmi Wiki - Server Browser Tags](https://wiki.facepunch.com/rust/server-browser-tags)

</details>

### 1.2 Ağ Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `SERVER_IP` | 0.0.0.0 | Sunucunun dinleyeceği IP adresi. (0.0.0.0 tüm arayüzler demektir) |
| `SERVER_PORT` | 28015 | Oyun bağlantı portu. (UDP) |
| `SERVER_QUERYPORT` | "" | Steam sorgu portu. (UDP. **Boş bırakılırsa otomatik hesaplanır:** en büyük port (oyun/RCON) + 1, varsayılan kurulumda 28017. Oyun portundan farklı olmalıdır; bu port açık değilse sunucu listede görünmez) |
| `RCON_IP` | 0.0.0.0 | RCON'un dinleyeceği IP. |
| `RCON_PORT` | 28016 | RCON bağlantı portu. (TCP) |
| `RCON_PASSWORD` | "change_me_rcon_pass" | RCON yönetici şifresi. **(Kesinlikle değiştirin!)** |
| `RCON_WEB` | 1 | Web RCON arayüzünü (RustAdmin vb.) aktif eder. |

### 1.3 Rust+ Companion App Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `RUSTPLUS_ENABLED` | 1 | Rust+ telefon uygulamasını aktif eder. |
| `APP_PORT` | 28082 | Rust+ portu. (TCP, Oyun portundan farklı olmalıdır) |
| `APP_LISTENIP` | "" | Rust+ için dinlenecek yerel IP. |
| `APP_PUBLICIP` | "" | Rust+ için dış IP adresi. |

### 1.4 Güvenlik & Anti-Cheat Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `SERVER_SECURE` | 1 | EAC (Easy Anti-Cheat) modülünü aktif eder. (0 = Devre dışı) |
| `SERVER_EAC` | 1 | Easy Anti-Cheat'in çalışmasını zorunlu kılar. |
| `SERVER_ENCRYPTION` | 1 | Paket şifrelemesini aktif eder. |
| `SERVER_STABILITY` | 1 | Yapı dayanıklılığını (bina yıkılma mekaniği) aktif eder. |
| `CODELOCK_LOCKOUTCOOLDOWN` | 900 | Şifreli kapılarda çok yanlış girilirse bekleme süresi. (sn) |
| `CODELOCK_MAXFAILEDATTEMPTS` | 8 | Maksimum hatalı şifre deneme sayısı. |
*Not: Eğer sadece arkadaşlarınızla oynamak için EAC'yi kapatacaksanız (`0` yapacaksanız), sunucunuz oyun içi listesinde **görünmez**, sadece IP ile (client.connect) bağlanılabilir.*

### 1.5 Performans Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `SERVER_TICKRATE` | 30 | Sunucu tick hızı. (Performans için 30-60 önerilir) |
| `SERVER_FPSLIMIT` | 120 | Maksimum sunucu FPS'i. (`+fps.limit` olarak gönderilir; motor varsayılanı 256) |
| `SERVER_SAVEINTERVAL` | 600 | Haritanın ne sıklıkla kaydedileceği. (sn, 600 = 10 dk) |
| `GC_INTERVAL` | "" | Garbage Collection (Bellek temizleme) aralığı. |
| `GC_BUFFERCOUNT` | "" | GC tampon boyutu. |
| `ENTITYBATCHSIZE` | "" | Saniye başına işlenecek entity limiti. |
| `GLOBAL_MAXTHREADS` | 8 | Sunucunun kullanabileceği maksimum işlemci iş parçacığı sayısı. |

### 1.6 Decay & Upkeep Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `DECAY_SCALE` | 1 | Çürüme hızı çarpanı. (0 = tamamen kapanır, 0.5 = yarı yarıya yavaşlar) |
| `DECAY_TICK` | 600 | Çürüme hesaplama sıklığı. |
| `DECAY_UPKEEP` | 1 | Tool Cupboard (Dolap) bakım sistemini açar/kapatır. |
| `DECAY_UPKEEP_PERIOD_MINUTES`| 1440 | Tam dolu bir dolabın koruma süresi. (1440 = 24 Saat) |
| `DECAY_UPKEEP_GROUP_SCALING` | 1 | Grup bakım vergisi (Eylül 2026 "Breach and Clear" güncellemesi). Dolapta yetkili kişi sayısına göre bakım maliyetini artırır. (0 = vergi tamamen kapalı) |
| `DECAY_DURATION_TOPTIER` | "" | Yüksek kalite (HQM) yapıların çürüme süresi. (Saat) |
| `DECAY_DURATION_METAL` | "" | Metal yapıların çürüme süresi. (Saat) |
| `DECAY_DURATION_STONE` | "" | Taş yapıların çürüme süresi. (Saat) |
| `DECAY_DURATION_WOOD` | "" | Ahşap yapıların çürüme süresi. (Saat) |
| `DECAY_DURATION_TWIG` | "" | Çalı (Twig) yapıların çürüme süresi. (Saat) |

### 1.7 Hayvan & NPC Popülasyon Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `BEAR_POPULATION` | 2 | Ayı sayısı çarpanı. (km² başına) |
| `BOAR_POPULATION` | 5 | Domuz sayısı çarpanı. (km² başına) |
| `CHICKEN_POPULATION` | 3 | Tavuk sayısı çarpanı. (km² başına) |
| `STAG_POPULATION` | 3 | Geyik sayısı çarpanı. (km² başına) |
| `WOLF2_POPULATION` | 2 | Kurt sayısı çarpanı. (km² başına. **Not:** `wolf.population`, Wolves2 güncellemesiyle `wolf2.population` olarak yeniden adlandırıldı; eski ad artık yok sayılır) |
| `POLARBEAR_POPULATION` | 1 | Kutup ayısı sayısı. (Kar biyomu, km² başına) |
| `TIGER_POPULATION` | 0.5 | Kaplan sayısı. (Jungle biyomu, km² başına) |
| `PANTHER_POPULATION` | 0.5 | Panter sayısı. (Jungle biyomu, km² başına) |
| `CROCODILE_POPULATION` | 1 | Timsah sayısı. (Jungle/bataklık, km² başına) |
| `SNAKEHAZARD_POPULATION` | 5 | Yılan sayısı. (Jungle bitki örtüsü, km² başına) |
| `COW_POPULATION` | "" | İnek sayısı. (Ekim 2026 "Livestock" güncellemesi, km² başına. Boş = vanilla) |
| `SHEEP_POPULATION` | "" | Koyun sayısı. (Ekim 2026 "Livestock" güncellemesi, km² başına. Boş = vanilla) |
| `NPCS_ENABLED` | 1 | NPC (bilim insanı vb.) spawning'in ana anahtarı. (0 = hiçbir NPC spawn olmaz) |
| `AI_TICKRATE` | 5 | NPC düşünme/hareket etme hızı. |
| `AI_IGNOREPLAYERS` | 0 | 1 yapılırsa hayvanlar ve NPC'ler oyunculara saldırmaz. |
| `AI_MOVE` | "" | Boş = varsayılan (1). 0 yapılırsa hayvanlar hareket etmez. (Performans için) |
| `AI_THINK` | "" | Boş = varsayılan (1). 0 yapılırsa NPC yapay zekası durur. (Performans için) |

### 1.8 Oyun İçi Event Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `CARGOSHIP_ENABLED` | 1 | Kargo gemisi etkinliğini açar/kapatır. |
| `CARGOSHIP_DURATION_MINUTES`| 50 | Kargo gemisinin haritada kalma süresi. (dk) |
| `CARGOSHIP_LOOT_ROUNDS` | 3 | Kargo gemisinde kaç kere sandık yenileneceği. |
| `CARGOSHIP_LOOT_SPACING_MINUTES` | 10 | Sandıkların yenilenme süresi aralığı. (dk) |
| `HELI_BULLETDMGSCALE` | "" | Devriye helikopteri mermi hasarı çarpanı. (1 = normal, 2 = 2 katı hasar. Boş = motor varsayılanı) |
| `BRADLEY_ENABLED` | 1 | Bradley APC (Tank) etkinliğini açar/kapatır. |
| `MISSIONS_ENABLED` | 1 | NPC görev sistemini açar/kapatır. |

> ℹ️ **Devriye helikopteri (Patrol Helicopter) notu:** Eski `patrolhelicopter.max` convar'ı güncel Rust sürümünde bulunmamaktadır; helikopter davranışını ince ayarlamak için sunucu konsolunda `find patrolhelicopterai` komutuyla güncel convar listesini görebilirsiniz.

### 1.9 Oynanış & Gelişmiş Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `SERVER_PVE` | 0 | 1 yapılırsa oyuncular birbirlerine hasar veremez. (Sadece çevreye ve NPC'lere) |
| `CRAFT_INSTANT` | "" | **Dikkat:** `craft.instant` convar'ı güncel Rust sürümünden kaldırılmıştır; anında üretim artık eklenti (plugin) gerektirir. Yalnızca eski sürümler için doldurun, boş bırakılırsa `server.cfg`'ye yazılmaz. |
| `SERVER_RADIATION` | 1 | Radyasyon bölgelerini açar/kapatır. (0 = anıtlarda radyasyon olmaz) |
| `SERVER_TEAMMAXSIZE` | 8 | Maksimum ekip (team) boyutu. (0 = takımlar tamamen kapalı, 3-4 = küçük grup sunucuları) |
| `SERVER_ITEMDESPAWN` | 180 | Yere atılan eşyaların kaybolma süresi. (sn) |
| `SERVER_BRANCH` | "public" | Rust sunucu sürümü dalı. (Staging vb. için değiştirilebilir) |

### 1.10 Dizin & Güncelleme Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `STEAMCMD_DIR` | "%~dp0steamcmd"| SteamCMD kurulum klasörü. |
| `SERVER_DIR` | "%~dp0server" | Rust Server kurulum klasörü. |
| `LOG_DIR` | "%~dp0logs" | Çökme (Crash) loglarının kaydedileceği klasör. |
| `AUTO_UPDATE` | 1 | Her açılışta SteamCMD üzerinden Rust güncellemesini kontrol eder. |
| `STEAMCMD_VALIDATE` | 1 | 1 = güncellemede dosya doğrulaması yapılır (güvenli, yavaş). 0 = `validate` atlanır (açılış hızlanır, bozuk dosyalar onarılmaz). |
| `LOG_RETENTION_DAYS` | 14 | Bu günden eski `server_*.log` dosyaları her başlatmada otomatik silinir. (0 = temizlik kapalı) |
| `ENABLE_UMOD` | 0 | 1 yapılırsa Oxide (uMod) eklenti sistemini otomatik kurar ve günceller. |

<details>
<summary><strong>📂 Dizin Yolları Nasıl Değiştirilir?</strong></summary>

#### 🔑 `%~dp0` Ne Demek?

`%~dp0`, BAT dosyasının **kendi bulunduğu klasörün tam yolunu** ifade eder. Örneğin script `C:\RustSunucu\` klasöründeyse:

| Değişken | Varsayılan Sonuç | Ne İşe Yarar? |
|---|---|---|
| `STEAMCMD_DIR` | `C:\RustSunucu\steamcmd` | SteamCMD dosyaları buraya iner |
| `SERVER_DIR` | `C:\RustSunucu\server` | Rust sunucu dosyaları buraya kurulur |
| `LOG_DIR` | `C:\RustSunucu\logs` | Çökme logları buraya kaydedilir |

#### ✏️ Değiştirme Örnekleri

**1) Başka bir diske taşımak isterseniz** (örneğin D sürücüsüne):

```bat
set "STEAMCMD_DIR=D:\RustServer\steamcmd"
set "SERVER_DIR=D:\RustServer\server"
set "LOG_DIR=D:\RustServer\logs"
```

**2) BAT dosyasının yanında kalsın ama klasör adını değiştirmek isterseniz:**

```bat
set "STEAMCMD_DIR=%~dp0steam"
set "SERVER_DIR=%~dp0rust_dosyalar"
set "LOG_DIR=%~dp0kayitlar"
```

**3) Tamamen farklı yollara taşımak isterseniz:**

```bat
set "STEAMCMD_DIR=C:\OyunAraclari\steamcmd"
set "SERVER_DIR=D:\Sunucular\Rust"
set "LOG_DIR=D:\Sunucular\Rust_Loglari"
```

> ⚠️ **Dikkat Edilmesi Gerekenler:**
> - Tırnak işaretlerini (`"`) silmeyin → `set "DEGISKEN=deger"` formatında kalmalıdır.
> - Yol ayracı olarak ters eğik çizgi (`\`) kullanın, düz eğik çizgi (`/`) değil.
> - Boşluk içeren yollar sorun çıkarmaz çünkü değer tırnak içinde tanımlanır.
> - Klasörü kendiniz oluşturmanıza gerek yoktur; script çalıştırıldığında otomatik oluşturulur.

</details>

### 1.11 Crash & Yeniden Başlatma Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `CRASH_RESTART` | 1 | Sunucu beklenmedik şekilde çökerse otomatik yeniden başlatmayı açar. |
| `CRASH_WAIT_SECONDS` | 30 | Çöktükten sonra yeniden başlatmak için beklenecek süre. (sn) |
| `MAX_CRASH_RESTARTS` | 5 | Sonsuz döngüyü önlemek için maksimum ardışık yeniden başlatma denemesi. |
| `CRASH_RESET_UPTIME_SECONDS` | 300 | Sunucu bu süre boyunca kesintisiz ayakta kaldıysa crash sayacı sıfırlanır. Böylece uzun süre sağlıklı çalışan bir sunucu, seyrek çökmelerde yeniden başlatma hakkını kaybetmez. (sn) |

### 1.12 Yönetici & Yetki Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `SERVER_OWNERS` | "" | Sunucu sahibi (Owner) olarak atanacak Steam64ID'ler. Virgülle ayrılır. |
| `SERVER_MODERATORS` | "" | Moderatör olarak atanacak Steam64ID'ler. Virgülle ayrılır. |

<details>
<summary><strong>👑 Yönetici & Yetki Ayarları Nasıl Kullanılır?</strong></summary>

#### 🔑 Steam64ID Nasıl Bulunur?

1. Steam istemcisini açın.
2. Sağ üst köşeden profil adınıza tıklayın → **Hesap ayrıntıları**.
3. Sayfanın alt kısmında **Steam ID** yazan 17 haneli numara sizin Steam64ID'nizdir.

Alternatif olarak [steamid.io](https://steamid.io/) sitesinden Steam profil URL'nizi yapıştırarak da bulabilirsiniz.

#### ✏️ Örnek Kullanımlar

**Tek sahip ekleme:**

```bat
set "SERVER_OWNERS=76561198000000001"
```

**Birden fazla sahip ekleme** (virgülle ayırın):

```bat
set "SERVER_OWNERS=76561198000000001,76561198000000002"
```

**Sahip ve moderatör birlikte ekleme:**

```bat
set "SERVER_OWNERS=76561198000000001"
set "SERVER_MODERATORS=76561198000000003,76561198000000004"
```

#### 📋 Yetki Seviyeleri

| Yetki | Komut | Açıklama |
|-------|-------|----------|
| **Owner (Sahip)** | `ownerid` | Tam yönetici yetkisi. Tüm konsol komutlarını kullanabilir, kick/ban yapabilir, F1 menüsünde tüm admin araçlarına erişir. |
| **Moderator (Moderatör)** | `moderatorid` | Sınırlı yönetici yetkisi. Kick/ban yapabilir ancak bazı gelişmiş komutlara erişemez. |

> ⚠️ **Önemli Notlar:**
> - En az bir `SERVER_OWNERS` değeri girmeniz önerilir; aksi takdirde sunucunuzda yönetici yetkisi olan kimse olmaz.
> - Steam64ID 17 haneli olmalıdır. Yanlış ID girerseniz ilgili oyuncuya yetki atanmaz.
> - Yetkiler her sunucu başlatmada `server.cfg` dosyasına otomatik yazılır, manuel düzenlemenize gerek yoktur.
> - `SERVER_OWNERS` ve `SERVER_MODERATORS` boş bırakılırsa (`""`) bu satırlar `server.cfg`'ye eklenmez.

</details>

### 1.13 Ekim 2026 "Livestock" Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `SERVER_OLD_NAVMESH` | 0 | 0 = yeni navmesh (Ekim 2026'dan itibaren varsayılan). 1 = başlatma parametresine `-useOldNavmesh` eklenir ve eski davranışa dönülür. |
| `VEHICLE_PADREPAIRSREQUIRED` | 1 | Air Wolf helipad'inin onarım gerektirmesini kontrol eder. (0 = helipad onarım istemez) |
| `VEHICLE_SETREPAIRABLEPADS` | "" | Helipad'i zorla bozuk (0) veya onarılmış (1) duruma alır. Boş = hiç yazılmaz, sunucu değeri korunur. |
| `POWERGRID_FUSEDECAYLOWPOP` | 10 | Powergrid sigortası çürümesinin başladığı oyuncu sayısı eşiği. |
| `POWERGRID_FUSEDECAYHIGHPOP` | 100 | Sigorta çürümesinin en yüksek hıza ulaştığı oyuncu sayısı. |
| `POWERGRID_FUSEDECAYLOWPOPSCALE` | 4 | Düşük popülasyondaki çürüme hızı çarpanı. |
| `SERVER_UPGRADE_KEEPS_HEALTH` | 1 | Yükseltilen yapıda mevcut hasar oranının korunmasını sağlar. (Vanilla davranışı) |

> ℹ️ **Yeni navmesh ne getirdi?** Ekim 2026 güncellemesiyle NPC'ler oyuncu yapılarına girip kapıları kullanabiliyor. Bu davranıştan rahatsızsanız `SERVER_OLD_NAVMESH=1` yaparak eski navmesh'e dönebilirsiniz; ancak eski navmesh ileride kaldırılabilir.
> ℹ️ **Popülasyon anahtarları (`COW_POPULATION`, `SHEEP_POPULATION`):** Boş bırakıldığında `server.cfg`'ye hiç yazılmaz ve vanilla değer geçerli olur. Güncel anahtar adlarını sunucu konsolunda `find livestock` komutuyla doğrulayabilirsiniz.
> ⚠️ Bu anahtarlar yalnızca güncel Rust sürümünde desteklenir. Eski bir sunucu sürümü kullanıyorsanız ilgili satır hata mesajı üretmez, sadece yok sayılır.

### 1.14 Test & Tanı Ayarları
| Parametre | Varsayılan Değer | Açıklama |
|-----------|------------------|----------|
| `FG_DRY_RUN` | 0 | 1 = kuru çalıştırma modu. Yönetici izni, güç planı, dizin oluşturma, SteamCMD indirme/güncelleme, uMod kurulumu, firewall değişikliği ve sunucu başlatma adımları **atlanır**; üretilecek `server.cfg` içeriği ile başlatma parametreleri ekrana yazılır. Sistemde kalıcı hiçbir değişiklik yapılmaz. |

**Kuru çalıştırma örneği:**

```bat
set "FG_DRY_RUN=1"
```

> 💡 Bu mod, yeni ayarları canlı sunucuya dokunmadan doğrulamak için idealdir. Testten sonra değeri tekrar `0` yapmayı unutmayın.

---

## ▶️ Çalıştırma

Projeyi başlatmak ve test etmek için:

1. Klasördeki `fg-RustServerStart.BAT` dosyasına çift tıklayın.
2. (Gerekirse) Ekrana gelen Yönetici İzni (UAC) uyarısına "Evet" deyin. Script güvenlik duvarı kurallarını eklemek için bu izne ihtiyaç duyar.
3. Script sırasıyla;
   - Gerekli klasörleri oluşturur ve `LOG_RETENTION_DAYS` süresinden eski logları temizler,
   - Yapılandırma ön kontrollerini yapar (varsayılan RCON şifresi, boş `SERVER_OWNERS`, EAC kapalı uyarıları),
   - İşletim sistemini performans moduna (Windows Server 2022 vb. için Yüksek Performans) alır,
   - SteamCMD'yi indirir ve kurar (3 denemeli, boyut doğrulamalı kurulum),
   - Rust Dedicated Server dosyalarını indirir/günceller (`STEAMCMD_VALIDATE` ile doğrulama kontrolü),
   - (Açıksa) uMod'u indirip kurar,
   - Güvenlik Duvarı portlarını (oyun, RCON, Rust+, queryport) açar,
   - `server.cfg` dosyasını yapılandırarak sunucuyu başlatır.
4. Konsolda `Server startup complete` mesajını gördüğünüzde sunucunuz aktiftir! 😎

---

## 🧯 Sorun Giderme

### Konsol firewall mesajından sonra hemen kapanırsa

v1.4.4 ile script artık kendini güvenli bir dış çalıştırıcı üzerinden başlatır. Bu sayede Windows Server 2022 üzerinde firewall kuralı, `server.cfg` üretimi veya başlatma parametrelerinde hata oluşsa bile konsol penceresi otomatik kapanmaz; hata kodu ve ilgili mesaj ekranda kalır.

Firewall tarafında her port ayrı ayrı kontrol edilir:

- Oyun portu: `SERVER_PORT` / UDP
- RCON portu: `RCON_PORT` / TCP
- Rust+ açıksa: `APP_PORT` / TCP
- Sorgu portu (Queryport): `SERVER_QUERYPORT` / UDP (boşsa otomatik hesaplanır: en büyük port + 1)

Bir firewall kuralı eklenemezse script artık sessizce kapanmak yerine hangi portta hata olduğunu gösterir. Bu durumda scripti **Yönetici olarak** çalıştırın ve Windows Defender Firewall servisinin açık olduğundan emin olun. 🛡️

### Sunucu tarayıcı listesinde görünmüyorsa

Şubat 2023 ağ güncellemesinden itibaren Rust, sunucunun listede görünmesi için **sorgu portu (queryport)** zorunlu tutuyor:

- `SERVER_QUERYPORT` boşsa script bunu otomatik hesaplar (varsayılan kurulumda **28017**) ve hem `+server.queryport` parametresini hem de UDP firewall kuralını ekler.
- Queryport, oyun portuyla **aynı olamaz** ve UDP olarak dışarıya açık olmalıdır.
- Sunucunuz hâlâ listede çıkmıyorsa router'ınızda da UDP 28017 port yönlendirmesini yapın.

### `'Vanilla+' is not recognized` hatası

Bu hata, sunucu adı/açıklaması/tag gibi başlatma parametrelerinde `|`, `&`, `!` gibi Windows CMD özel karakterleri geçtiğinde oluşur. v1.4.4 ile başlatma parametreleri güvenli biçimde hazırlanır ve `RustDedicated.exe` çalıştırılırken gecikmeli değişken genişletme kapatılır. Böylece `Vanilla+ | Monthly` gibi değerler komut olarak algılanmaz.

### NPC'ler üsse giriyor / kapıları açıyor

Ekim 2026 "Livestock" güncellemesiyle yeni navmesh varsayılan hale geldi ve NPC'ler oyuncu yapılarına girebiliyor, kapıları kullanabiliyor:

- Bu davranışı kapatmak için `SERVER_OLD_NAVMESH=1` yapın (başlatma parametrelerine `-useOldNavmesh` eklenir).
- Eski navmesh ileride kaldırılabilir; kalıcı çözüm için üs tasarımınızı (hava kilidi, kapı düzeni) buna göre düzenlemeniz önerilir.
- Değişikliği canlı sunucuya dokunmadan denemek için `FG_DRY_RUN=1` ile kuru çalıştırma yapıp yazdırılan parametre listesini kontrol edebilirsiniz.

### Ayarları riske atmadan test etmek istiyorsanız

`FG_DRY_RUN=1` yapıp scripti çalıştırın. Script hiçbir kurulum, firewall veya sunucu işlemi yapmaz; yalnızca üretilecek `server.cfg` içeriğini ve `RustDedicated.exe` parametrelerini ekrana yazar. Böylece yeni convar'ların doğru yazıldığını canlı sunucuyu etkilemeden görebilirsiniz.

### Loglar gereksiz yer kaplıyorsa

`LOG_RETENTION_DAYS` değerini düşürün (örn. `7`). Bu süreden eski `server_*.log` dosyaları her başlatmada otomatik silinir. Tamamen kapatmak için `0` yazın.

---

## 📁 Dosya Yapısı

Kurulum ve ilk çalıştırma sonrasında proje dizin organizasyonu şu şekilde olacaktır:

```text
fg-RustServerStartBat/
│
├── fg-RustServerStart.BAT    # Ana yürütme ve otomasyon scripti
├── .gitignore                # Git tarafından takip edilmeyecek dosyalar
├── LICENSE                   # MIT Lisans dosyası
├── README.md                 # Bu dokümantasyon dosyası
├── AGENTS.md                 # Proje kuralları ve referans tanımları
│
├── steamcmd/                 # (Otomatik oluşur) SteamCMD dosyaları
├── logs/                     # (Otomatik oluşur) Crash ve konsol logları
│   └── server_YYYY-MM-DD_HHMM.log
│
└── server/                   # (Otomatik oluşur) Rust Dedicated Server
    ├── RustDedicated.exe     # Ana oyun motoru yürütülebilir dosyası
    ├── RustDedicated_Data/   # Oyun verileri ve (kuruluysa) uMod/Oxide klasörü
    └── server/
        └── feyioz_rust/      # Sunucu kimliğine (identity) göre oluşan kayıt dizini
            └── cfg/
                └── server.cfg # Otomatik üretilen ayar dosyası
```

---

## 🤝 Katkı Sağlama

Geliştirici rehberimiz basittir: Herkes katkıda bulunabilir! ✨

1. Bu depoyu `fork` edin.
2. Kendinize yeni bir branch oluşturun (`git checkout -b feature/YeniÖzellik`).
3. Değişikliklerinizi yapın ve commit atın (`git commit -m 'Yeni bir özellik eklendi'`).
4. Branch'inizi pushlayın (`git push origin feature/YeniÖzellik`).
5. Bir Pull Request (PR) oluşturun.

*Not: Yaptığınız değişikliklerden sonra `fg-RustServerStart.BAT` içerisinde veya işleyişinde bir fark oluşursa, lütfen `README.md` dosyasını da buna uygun olarak güncelleyin.*

---

## 📚 Daha Diğer

Projeyle ilgili diğer önemli bilgiler, sunucu yönetimi, komutlar ve eklentiler hakkında daha fazla bilgi için aşağıdaki resmi kaynakları kullanabilirsiniz:

### Yardımcı Kaynaklar
- **Facepunch Resmi Rust Wiki:** [https://wiki.facepunch.com/rust/](https://wiki.facepunch.com/rust/)
- **uMod (Oxide) Resmi Dokümantasyon:** [https://umod.org/documentation](https://umod.org/documentation)
- **Valve Developer Community (SteamCMD):** [https://developer.valvesoftware.com/wiki/SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)

Script Windows Server 2022 Standard işletim sisteminde çalışacağı için bu ortama tam uyumluluk düşünülerek tasarlanmıştır.

---

## 🔄 Versiyon Geçmişi

- **v1.5.0:** Ekim 2026 "Livestock" güncellemesiyle tam senkron sağlandı. Yeni navmesh artık varsayılan olduğu için eski `-useNewNavmesh` parametresi kaldırıldı; geri dönüş isteyenler için `SERVER_OLD_NAVMESH` (`-useOldNavmesh`) eklendi. Yeni convar'lar: `vehicle.padrepairsrequired`, `vehicle.setrepairablepads` (Air Wolf helipad onarımı), `powergrid.fusedecaylowpop`/`fusedecayhighpop`/`fusedecaylowpopscale` (sigorta çürümesi), `server.upgrade_keeps_health` ve isteğe bağlı `COW_POPULATION`/`SHEEP_POPULATION`. Optimizasyonlar: `wmic` bağımlılığı kaldırıldı (zaman damgası artık PowerShell ile alınır; eski sistemler için `wmic`, son çare olarak `%DATE%` yedeği), SteamCMD indirmesi 3 denemeli ve boyut doğrulamalı hale getirildi, `STEAMCMD_VALIDATE=0` ile her açılışta yapılan dosya doğrulaması atlanabiliyor, `LOG_RETENTION_DAYS` (varsayılan 14 gün) ile eski loglar otomatik temizleniyor, `CRASH_RESET_UPTIME_SECONDS` (varsayılan 300 sn) ile uzun süre sağlıklı çalışan sunucularda crash sayacı sıfırlanıyor, firewall kuralları `profile=any enable=yes` ile eklendi ve yapılandırma ön kontrol uyarıları (varsayılan RCON şifresi, boş `SERVER_OWNERS`, EAC kapalı) eklendi. Yeni `FG_DRY_RUN=1` kuru çalıştırma modu sayesinde sistemde hiçbir değişiklik yapmadan `server.cfg` ve başlatma parametreleri önizlenebiliyor. Ayrıca gecikmeli değişken genişletmesi nedeniyle konsol mesajlarındaki `!` karakterlerinin yutulması ve blok içindeki parantezli mesajların komut sanılması sorunları giderildi; tüm PowerShell çağrılarına `-NoProfile` eklendi. Windows Server 2022 uyumluluğu korundu.
- **v1.4.12:** Rust'ın güncel (2026) sürümüne göre kapsamlı convar senkronizasyonu yapıldı: `wolf.population` → `wolf2.population` (Wolves2 güncellemesi), `heli.bulletdamage` → `heli.bulletdamagescale`, `cargoship.loot_spacing_minutes` → `cargoship.loot_round_spacing_minutes`, `+server.fps` → `+fps.limit` geçildi ve vanilla'dan kaldırılan `craft.instant` isteğe bağlı hale getirildi. Queryport artık boş bırakılırsa otomatik hesaplanıyor (en büyük port + 1) ve UDP firewall kuralıyla birlikte gönderiliyor; böylece sunucunun listede görünmemesi sorunu giderildi. Yeni ayarlar eklendi: `SERVER_LOGOIMAGE`, `SERVER_RADIATION`, `SERVER_TEAMMAXSIZE` (ekip boyutu), `NPCS_ENABLED` (`ai.npc_enable`), `AI_MOVE`/`AI_THINK`, kutup ayısı/kaplan/panter/timsah/yılan popülasyonları ve Eylül 2026 "Breach and Clear" güncellemesinin grup bakım vergisi anahtarı (`DECAY_UPKEEP_GROUP_SCALING`). Geçersiz `patrolhelicopter.max` convar'ı kaldırıldı. Minimum RAM gereksinimi Facepunch wiki'ye göre 12 GB olarak güncellendi. Windows Server 2022 uyumluluğu korundu.
- **v1.4.11:** README.md, AGENTS.md kurallarına göre güncellendi; "Proje Kuralları" bölümü AGENTS.md ile hizalandı ve BAT–README versiyon senkronu (1.4.11) sağlandı. Script mantığında değişiklik yoktur.
- **v1.4.10:** uMod/Oxide kurulumundaki powershell satırında bulunan "!" ünlem işaretlerinin gecikmeli değişken genişletme (DelayedExpansion) tarafından yutulmasıyla oluşan "Missing closing ')' in expression" syntax hatası çözüldü. Script Windows Server 2022 uyumluluğu korundu.
- **v1.4.9:** Otomatik uMod (Oxide) kurulumu özelliği güncellendi. Artık konsolda en son yayımlanan 5 Windows sürüm (v2.0.7283 vb.) seçeneği listeleniyor ve seçilen sürüm yükleniyor. Gereksiz test dosyaları silindi. Script Windows Server 2022 uyumluluğuna sahiptir.
- **v1.4.8:** uMod (Oxide) kurulum adımına gelişmiş bir hata yakalama (try/catch) döngüsü eklendi. Arka planda açık kalan sunucu dosyalarının (Assembly-CSharp.dll) modifiye edilmesini engelleyen Windows kilitleri (Read-Only) artık zorla aşılıyor. Ayrıca kurulum bitiminde doğrulama kontrolü eklendi; Oxide kurulamazsa script otomatik olarak duraklıyor ve kırmızı renkli bir uyarı veriyor. Windows Server TLS 1.2 protokol zorunluluğu giderildi.
- **v1.4.7:** PowerShell'in `Expand-Archive` cmdlet'inin mevcut dosyaların üzerine yazma sırasındaki yetersizliği düzeltildi. UMod dosyaları artık `.NET` Compression sınıfları aracılığıyla daha güçlü ve hatasız bir şekilde çıkartılıyor.
- **v1.4.6:** uMod/Oxide'in `.zip` arşiv içeriğinden kaynaklanan yanlış klasöre çıkartılma (`RustDedicated_Data\RustDedicated_Data`) sorunu çözüldü. Ayrıca, SteamCMD güncellemelerinin Oxide modifikasyonlarını silmesini engellemek için, sürüm aynı olsa bile her başlatmada Oxide dosyalarının yerel arşivden orijinal dosyaların üzerine yazılması sağlandı.
- **v1.4.5:** uMod/Oxide için akıllı sürüm kontrolü eklendi; artık her açılışta gereksiz yere baştan indirilmiyor, sadece yeni bir sürüm varsa otomatik güncelleniyor.
- **v1.4.4:** `Vanilla+ | ...` gibi özel karakter içeren sunucu adı/tag değerlerinin CMD tarafından komut sanılmasına neden olan başlatma parametresi hatası düzeltildi.
- **v1.4.3:** Windows Server 2022'de firewall adımından sonra konsolun aniden kapanmasını engelleyen güvenli dış çalıştırıcı eklendi; firewall kuralları port bazlı doğrulama ve açık hata mesajlarıyla güçlendirildi.
- **v1.4.2:** Firewall ayarlarından hemen sonra boş Owner/Moderator listesi kontrolünde yaşanan syntax hatası (script'in aniden kapanması) çözüldü.
- **v1.4.1:** SteamCMD'nin "CWorkThreadPool" hatası fırlatması ve scriptin aniden kapanması sorunu düzeltildi. 3 aşamalı indirme döngüsü (retry mekanizması) eklendi.
- **v1.4.0:** Gelişmiş sunucu ayarları eklendi.

İyi oyunlar dileriz! 🚀🔥
