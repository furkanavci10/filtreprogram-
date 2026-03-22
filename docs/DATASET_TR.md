# Turkish SMS Dataset

This is a synthetic, privacy-safe regression corpus for Turkish SMS filtering. It is intentionally conservative and designed to stress false-positive protections.

Columns:

- `ID`: unique sample id
- `Domain`: scenario family
- `Text`: sample SMS text
- `Expected`: expected category
- `Reasoning`: why the sample should route there

| ID | Domain | Text | Expected | Reasoning |
| --- | --- | --- | --- | --- |
| 001 | BANK | Garanti BBVA: 1.250,00 TL tutarinda kart harcamaniz yapildi. Islem size ait degilse 4440333'u arayin. | ALLOW_CRITICAL | Real bank transaction alert with amount and fraud guidance. |
| 002 | BANK | Is Bankasi: Internet subesi giris denemeniz icin onay kodunuz 482911. Kimseyle paylasmayin. | ALLOW_CRITICAL | OTP plus bank security phrasing. |
| 003 | BANK | Ziraat Bankasi kartinizla 799,90 TL odeme yapildi. Bilginiz disindaysa hemen arayin. | ALLOW_CRITICAL | Security-sensitive payment confirmation. |
| 004 | BANK | Akbank: Supheli islem tespit edildi. Mobil giris icin tek kullanimlik sifreniz 903144. | ALLOW_CRITICAL | Fraud plus one-time code. |
| 005 | BANK | QNB Finansbank: 15.03.2026 tarihli 350 TL EFT isleminiz gerceklesti. | ALLOW_CRITICAL | Confirmed bank transfer. |
| 006 | BANK | VakifBank: Kart sifrenizi yenileme talebiniz icin onay kodu 112233. | ALLOW_CRITICAL | Explicit security code. |
| 007 | BANK | Enpara.com: Hesabiniza 4.500 TL para girisi olmustur. | ALLOW_CRITICAL | Bank account transaction. |
| 008 | BANK | DenizBank: 3D Secure sifreniz 887766. Bu kodu kimseyle paylasmayin. | ALLOW_CRITICAL | 3D Secure OTP. |
| 009 | BANK | Halkbank: Mobil onay kodunuz 105090. Sadece giris islemleriniz icindir. | ALLOW_CRITICAL | Strong OTP structure. |
| 010 | BANK | Kuveyt Turk: 1.200 TL FAST isleminiz tamamlandi. | ALLOW_CRITICAL | Financial transaction completion. |
| 011 | BANK | TEB: Kredi kartinizla 59,99 TL Spotify harcamaniz gerceklesti. | ALLOW_CRITICAL | Merchant and amount indicate legitimate alert. |
| 012 | BANK | ING: Hesap sifrenizi sifirlama kodunuz 660821. | ALLOW_CRITICAL | Password reset code. |
| 013 | BANK | Garanti BBVA: Kart limit artisi talebiniz alinmistir. Onay kodu 884422. | ALLOW_CRITICAL | Bank action confirmation. |
| 014 | BANK | Yapi Kredi: Dijital aktivasyon kodunuz 414141. Guvenliginiz icin kimseyle paylasmayin. | ALLOW_CRITICAL | Secure activation flow. |
| 015 | BANK | Ziraat Katilim: 980 TL fatura odemeniz basariyla tamamlandi. | ALLOW_CRITICAL | Payment confirmation. |
| 016 | BANK | Odeabank: Yeni cihaz tanimlama kodunuz 232323. | ALLOW_CRITICAL | Device verification code. |
| 017 | BANK | Turkiye Finans: Kartiniz internet alisverisine acilmistir. Bilgi: 4440244 | ALLOW_CRITICAL | Card security configuration notice. |
| 018 | BANK | Albaraka: 6.750 TL havale isleminiz tamamlandi. | ALLOW_CRITICAL | Financial transaction notice. |
| 019 | BANK | Akbank: 14:22'de mobil bankacilik girisiniz onaylandi. | ALLOW_CRITICAL | Security login confirmation. |
| 020 | BANK | Garanti BBVA: Sanal kart olusturma kodunuz 515151. | ALLOW_CRITICAL | Bank verification code. |
| 021 | OTP | Trendyol onay kodunuz: 483920. 3 dakika icinde giriniz. | ALLOW_CRITICAL | Standard OTP wording. |
| 022 | OTP | Hepsiburada dogrulama kodu 771204. Bu kodla giris yapabilirsiniz. | ALLOW_CRITICAL | Trusted login verification structure. |
| 023 | OTP | n11 sifre yenileme kodunuz 635200. | ALLOW_CRITICAL | Password reset code. |
| 024 | OTP | BiTaksi giris kodunuz 521899. Kimseyle paylasmayin. | ALLOW_CRITICAL | App login code. |
| 025 | OTP | Getir onay kodu: 290118 | ALLOW_CRITICAL | One-time code phrasing. |
| 026 | OTP | Yemeksepeti hesabiniz icin aktivasyon kodu 901455. | ALLOW_CRITICAL | Account activation message. |
| 027 | OTP | Sahibinden tek kullanimlik sifre: 500321 | ALLOW_CRITICAL | One-time password phrasing. |
| 028 | OTP | eBA okul giris kodunuz 408890. | ALLOW_CRITICAL | Education-related verification code. |
| 029 | OTP | Netflix oturum acma kodunuz 300155. | ALLOW_CRITICAL | Clear login code. |
| 030 | OTP | Amazon TR guvenlik kodunuz 881002. | ALLOW_CRITICAL | Security/OTP. |
| 031 | OTP | Migros uygulama giris kodu: 337744 | ALLOW_CRITICAL | Harmless authentication flow. |
| 032 | OTP | A101 Plus sifre dogrulama kodunuz 155844. | ALLOW_CRITICAL | Verification code. |
| 033 | OTP | Turkcell Sifre Islemleri: tek kullanimlik kodunuz 202760. | ALLOW_CRITICAL | Security code. |
| 034 | OTP | Vodafone Yanimda onay kodu 909080. | ALLOW_CRITICAL | Account verification. |
| 035 | OTP | Papara hesap onay kodunuz 772299. | ALLOW_CRITICAL | Financial app verification. |
| 036 | OTP | Biletix islem onay kodu 604318. | ALLOW_CRITICAL | Transaction code. |
| 037 | OTP | Kariyer.net giris kodu 748821. | ALLOW_CRITICAL | Login verification. |
| 038 | OTP | E-Posta dogrulama kodunuz: 414209 | ALLOW_CRITICAL | Generic safe OTP. |
| 039 | OTP | Hesabiniz icin dogrulama kodu 880144. Kodun gecerlilik suresi 5 dk. | ALLOW_CRITICAL | Strong OTP structure. |
| 040 | OTP | Guncelleme onayi icin kodunuz 123456. Bu mesaj otomatik gonderildi. | ALLOW_CRITICAL | Still an OTP pattern even if generic. |
| 041 | CARGO | Aras Kargo: 438219 takip nolu gonderiniz dagitima cikarilmistir. | ALLOW_TRANSACTIONAL | Real cargo tracking language. |
| 042 | CARGO | Yurtici Kargo: Kargonuz teslim edilmistir. Teslim alan: Ahmet. | ALLOW_TRANSACTIONAL | Delivery completion. |
| 043 | CARGO | MNG Kargo: 902134 takip no'lu paketiniz subeye ulasmistir. | ALLOW_TRANSACTIONAL | Shipment state update. |
| 044 | CARGO | PTT Kargo: Gonderiniz dagitim merkezindedir. Takip no: KP12345 | ALLOW_TRANSACTIONAL | Legit cargo wording. |
| 045 | CARGO | Trendyol Express: Siparisiniz bugun 18:00-22:00 arasinda teslim edilecektir. | ALLOW_TRANSACTIONAL | Delivery window. |
| 046 | CARGO | HepsiJET: Paketiniz kuryeye verildi. Canli takip icin uygulamayi acin. | ALLOW_TRANSACTIONAL | E-commerce logistics. |
| 047 | CARGO | Surat Kargo: 700912 takip numarali kargonuz teslimata cikmistir. | ALLOW_TRANSACTIONAL | Standard carrier message. |
| 048 | CARGO | Aras Kargo: Teslimat kodunuz 4412. Kurye geldiginde paylasiniz. | ALLOW_TRANSACTIONAL | Delivery code, not account OTP. |
| 049 | CARGO | Yurtici Kargo: Adresinizde bulunamadiniz. Gonderi subeden alinabilir. | ALLOW_TRANSACTIONAL | Legit operational notice. |
| 050 | CARGO | PTT: Kargonuz 2 is gunu icinde dagitima verilecektir. | ALLOW_TRANSACTIONAL | Neutral shipment notice. |
| 051 | CARGO | MNG Kargo: Gonderiniz iade surecine alinmistir. | ALLOW_TRANSACTIONAL | Operational logistics. |
| 052 | CARGO | Kargoist: 38182 takip numarali teslimatiniz yarin dagitima cikacak. | ALLOW_TRANSACTIONAL | Delivery scheduling. |
| 053 | CARGO | Scotty: Paketiniz teslim edildi. Degerlendirme yapabilirsiniz. | ALLOW_TRANSACTIONAL | Completed delivery. |
| 054 | CARGO | Sendeo: Teslimat icin size ulasamiyoruz, lutfen adresinizi uygulamadan kontrol edin. | ALLOW_TRANSACTIONAL | Transactional support flow. |
| 055 | CARGO | Trendyol Express: Kurye kapida, teslim kodunuz 6621. | ALLOW_TRANSACTIONAL | Delivery verification code. |
| 056 | CARGO | HepsiJET: Paketiniz transfer merkezine ulasti. | ALLOW_TRANSACTIONAL | Routine update. |
| 057 | CARGO | Aras Kargo: 3 parcadan olusan gonderinizin 1 parcasi teslim edilmistir. | ALLOW_TRANSACTIONAL | Shipment fragmentation, legit. |
| 058 | CARGO | Yurtici Kargo: Gonderi takip icin www.yurticikargo.com adresini ziyaret edebilirsiniz. | ALLOW_TRANSACTIONAL | Safe brand-domain logistics reference. |
| 059 | CARGO | PTT Kargo: Gonderiniz gumruk islemlerindedir. | ALLOW_TRANSACTIONAL | Legit cross-border logistics. |
| 060 | CARGO | MNG: Kargonuz teslim tarihi degisti, yeni tarih yarin. | ALLOW_TRANSACTIONAL | Delivery schedule change. |
| 061 | ECOMMERCE | Trendyol: 3 urunluk siparisiniz onaylandi. Toplam tutar 1.129,90 TL. | ALLOW_TRANSACTIONAL | Purchase confirmation. |
| 062 | ECOMMERCE | Hepsiburada: Iade talebiniz alinmistir. Sonuc 2 is gunu icinde bildirilecektir. | ALLOW_TRANSACTIONAL | Order support flow. |
| 063 | ECOMMERCE | n11: Siparisiniz kargoya verildi. | ALLOW_TRANSACTIONAL | Shipping update after order. |
| 064 | ECOMMERCE | Amazon.com.tr: 249 TL tutarli siparisiniz teslim edildi. | ALLOW_TRANSACTIONAL | E-commerce completion notice. |
| 065 | ECOMMERCE | LC Waikiki: Siparisiniz hazirlaniyor. | ALLOW_TRANSACTIONAL | Purchase progress. |
| 066 | ECOMMERCE | Teknosa: Online siparisiniz magaza teslimine hazirdir. | ALLOW_TRANSACTIONAL | Order pickup notification. |
| 067 | ECOMMERCE | MediaMarkt: Kurulum randevunuz olusturuldu. | ALLOW_TRANSACTIONAL | Post-purchase service. |
| 068 | ECOMMERCE | IKEA: Siparisinizin bir parcasi stok beklemektedir. | ALLOW_TRANSACTIONAL | Order update. |
| 069 | ECOMMERCE | CarrefourSA: Teslimatiniz 20:00'a kadar ulasacaktir. | ALLOW_TRANSACTIONAL | Grocery delivery update. |
| 070 | ECOMMERCE | Migros Hemen: Siparisiniz yola cikti. | ALLOW_TRANSACTIONAL | Delivery message. |
| 071 | ECOMMERCE | Getir: 189 TL odemeniz alindi, siparisiniz hazirlaniyor. | ALLOW_TRANSACTIONAL | Purchase/payment confirmation. |
| 072 | ECOMMERCE | Yemeksepeti: Siparisiniz restoranda hazirlaniyor. | ALLOW_TRANSACTIONAL | Food order status. |
| 073 | ECOMMERCE | Banabi: Siparisiniz teslim edildi. | ALLOW_TRANSACTIONAL | Delivery completion. |
| 074 | ECOMMERCE | Koctas: Fatura bilgileriniz basariyla guncellendi. | ALLOW_TRANSACTIONAL | Account/order administration. |
| 075 | ECOMMERCE | Gratis: Online siparisiniz iptal edilmistir, iadeniz 3 gun icinde yatacaktir. | ALLOW_TRANSACTIONAL | Refund/return notice. |
| 076 | ECOMMERCE | Watsons Club: Siparisiniz icin e-fatura olusturuldu. | ALLOW_TRANSACTIONAL | Invoice creation. |
| 077 | ECOMMERCE | Biletix: Etkinlik biletiniz hesabinizda goruntulenebilir. | ALLOW_TRANSACTIONAL | Ticket purchase flow. |
| 078 | ECOMMERCE | Pegasus BolBol: Satin alma isleminiz tamamlandi. PNR: AB12CD | ALLOW_TRANSACTIONAL | Travel purchase confirmation. |
| 079 | ECOMMERCE | Obilet: Seferiniz icin koltuk degisikligi yapildi. | ALLOW_TRANSACTIONAL | Reservation adjustment. |
| 080 | ECOMMERCE | Sahibinden Param Guvende: Isleminiz icin kargo kodu olusturuldu. | ALLOW_TRANSACTIONAL | Marketplace transaction support. |
| 081 | GOV | e-Devlet kapisi sifre yenileme talebiniz alinmistir. Onay kodu 661020. | ALLOW_CRITICAL | Government service security flow. |
| 082 | GOV | NVI: Kimlik randevunuz 24.03.2026 10:30 tarihinde olusturulmustur. | ALLOW_TRANSACTIONAL | Official appointment notice. |
| 083 | GOV | MHRS: Randevunuz 23.03.2026 14:00 icin onaylanmistir. | ALLOW_TRANSACTIONAL | Government healthcare reminder. |
| 084 | GOV | e-Devlet: Adres degisikligi bildiriminiz alinmistir. | ALLOW_TRANSACTIONAL | Official service update. |
| 085 | GOV | Gelir Idaresi: Dijital vergi dairesi giris kodunuz 700145. | ALLOW_CRITICAL | Official login verification. |
| 086 | GOV | Belediyemiz: Su kesintisi bildirimi yarin 09:00-15:00 arasindadir. | ALLOW_NORMAL | Informational civic message, harmless. |
| 087 | GOV | YSK secmen bilgi sorgulama kodunuz 553212. | ALLOW_CRITICAL | Verification code from official service. |
| 088 | GOV | EGM: Trafik cezaniz sisteme yansimistir, detay e-Devlet'te. | ALLOW_TRANSACTIONAL | Official informational alert. |
| 089 | GOV | SGK: Provizyon bilgilendirmeniz olusturuldu. | ALLOW_TRANSACTIONAL | Public healthcare administration notice. |
| 090 | GOV | e-Nabiz giris dogrulama kodunuz 441190. | ALLOW_CRITICAL | Official health login verification. |
| 091 | GOV | Turkiye.gov.tr hesabiniz icin onay kodu 710002. | ALLOW_CRITICAL | Official OTP despite generic wording. |
| 092 | GOV | Belediyemiz: Emlak vergisi son odeme tarihi 31 Mart'tir. | ALLOW_NORMAL | General reminder, not suspicious. |
| 093 | GOV | e-Devlet: Adli sicil belgeniz hazirdir. | ALLOW_TRANSACTIONAL | Official document status. |
| 094 | GOV | NVI: Pasaport basvurunuz basariyla teslim alinmistir. | ALLOW_TRANSACTIONAL | Official process confirmation. |
| 095 | GOV | Vergi Dairesi: Odeme bildiriminiz kayda alinmistir. | ALLOW_TRANSACTIONAL | Official payment acknowledgment. |
| 096 | HOSPITAL | Acibadem: Randevunuz 25.03.2026 09:15 icin olusturuldu. | ALLOW_TRANSACTIONAL | Hospital appointment reminder. |
| 097 | HOSPITAL | Memorial: MR sonucunuz sisteme yuklenmistir. | ALLOW_TRANSACTIONAL | Medical result notification. |
| 098 | HOSPITAL | MHRS: Yarin 13:45 muayene randevunuzu unutmayiniz. | ALLOW_TRANSACTIONAL | Healthcare reminder. |
| 099 | HOSPITAL | Medicana: Tahlil sonuclariniz cikmistir. | ALLOW_TRANSACTIONAL | Medical results are operational and safe. |
| 100 | HOSPITAL | Liv Hospital: Provizyon onayiniz tamamlandi. | ALLOW_TRANSACTIONAL | Medical billing/approval notification. |
| 101 | HOSPITAL | Florence Nightingale: Dogrulama kodunuz 412244 ile kayit tamamlanacaktir. | ALLOW_CRITICAL | Health service OTP. |
| 102 | HOSPITAL | Anadolu Saglik: Kontrol randevunuz 26 Mart 11:00. | ALLOW_TRANSACTIONAL | Appointment reminder. |
| 103 | HOSPITAL | Medical Park: Tetkik odemeniz alinmistir. | ALLOW_TRANSACTIONAL | Medical transaction confirmation. |
| 104 | HOSPITAL | MHRS giris kodunuz 300600. | ALLOW_CRITICAL | Official health login OTP. |
| 105 | HOSPITAL | Devlet Hastanesi: Hasta kabul siraniz 18 olarak guncellendi. | ALLOW_TRANSACTIONAL | Queue update. |
| 106 | HOSPITAL | Acil servis basvurunuz sisteme alinmistir. | ALLOW_TRANSACTIONAL | Hospital administration event. |
| 107 | HOSPITAL | E-Nabiz: laboratuvar sonuclariniz hazir. | ALLOW_TRANSACTIONAL | Health records notice. |
| 108 | HOSPITAL | MHRS: Randevu iptal talebiniz alindi. | ALLOW_TRANSACTIONAL | Appointment operation. |
| 109 | HOSPITAL | Hastane kayit kodunuz 6617. Giriste ibraz ediniz. | ALLOW_TRANSACTIONAL | Operational admission code, not account OTP. |
| 110 | HOSPITAL | Ozel Hastane: Policeniz icin provizyon reddedildi, cagri merkezini arayin. | ALLOW_TRANSACTIONAL | Insurance/medical operations. |
| 111 | TELECOM | Turkcell: Mart faturaniz 420,50 TL, son odeme tarihi 28.03.2026. | ALLOW_TRANSACTIONAL | Telecom billing reminder. |
| 112 | TELECOM | Vodafone: 10GB ek paketiniz tanimlandi. | ALLOW_TRANSACTIONAL | Plan update. |
| 113 | TELECOM | Turk Telekom: Taahhut bitis tarihiniz yaklasiyor. | ALLOW_TRANSACTIONAL | Account notice. |
| 114 | TELECOM | Turkcell Sifre Islemleri onay kodunuz 449901. | ALLOW_CRITICAL | Telecom account verification. |
| 115 | TELECOM | Vodafone Net: Ariza kaydiniz acilmistir. | ALLOW_TRANSACTIONAL | Service support update. |
| 116 | TELECOM | Turk Telekom: Faturaniz odendi, tesekkur ederiz. | ALLOW_TRANSACTIONAL | Payment confirmation. |
| 117 | TELECOM | Bimcell: Paketinizin suresi yarin doluyor. | ALLOW_TRANSACTIONAL | Service reminder. |
| 118 | TELECOM | Turkcell: Yurt disi kullanima acma talebiniz tamamlandi. | ALLOW_TRANSACTIONAL | Account configuration event. |
| 119 | TELECOM | Vodafone Yanimda giris kodu 551008. | ALLOW_CRITICAL | Login OTP. |
| 120 | TELECOM | Turk Telekom: Modem kurulum randevunuz 24.03.2026 icin planlandi. | ALLOW_TRANSACTIONAL | Operational appointment. |
| 121 | TELECOM | Turkcell Superonline: Ariza ekibimiz 16:00-18:00 arasinda gelecektir. | ALLOW_TRANSACTIONAL | Service appointment. |
| 122 | TELECOM | Vodafone: Tarifenize ek 5GB hediye tanimlandi. | ALLOW_TRANSACTIONAL | Carrier account-related safe message. |
| 123 | TELECOM | Turk Telekom: Numara tasima basvurunuz alinmistir. | ALLOW_TRANSACTIONAL | Telecom process. |
| 124 | TELECOM | Turkcell: Mobil odeme isleminiz 129 TL icin gerceklesti. | ALLOW_CRITICAL | Payment confirmation. |
| 125 | TELECOM | Vodafone: Cagri merkezi geri arama talebiniz kayda alindi. | ALLOW_TRANSACTIONAL | Operational update. |
| 126 | SPAM_BAHIS | Super bonus firsati! Bahis hesabini ac, 5000 TL deneme bonusu hemen seninle. bit.ly/x7 | FILTER_SPAM | Betting terms plus bonus bait and short link. |
| 127 | SPAM_BAHIS | iddaa severlere ozel freebet 300 TL. Kayit ol kazan. | FILTER_SPAM | Illegal betting vocabulary. |
| 128 | SPAM_BAHIS | Bugun mac oranlari uctu, kuponunu simdi yap, kazanmaya basla! | FILTER_SPAM | Betting call to action. |
| 129 | SPAM_BAHIS | Casino vip girisiniz acildi, yatirimsiz bonus icin tikla. | FILTER_SPAM | Casino, bonus, click bait. |
| 130 | SPAM_BAHIS | BAHIS 7/24 aktif, cevrimsiz bonus ve limitsiz cekim burada. | FILTER_SPAM | Strong betting spam markers. |
| 131 | SPAM_BAHIS | Oranlar burada, mac kuponu hazir, linke gel. | FILTER_SPAM | Clear betting pattern. |
| 132 | SPAM_BAHIS | Slot ve casino oyuncularina 250 free spin hediyesi. | FILTER_SPAM | Gambling promotion. |
| 133 | SPAM_BAHIS | Yatirim bonusu 100%, yeni uyelere ozel bahis kampanyasi. | FILTER_SPAM | Betting and bonus combination. |
| 134 | SPAM_BAHIS | Hemen uye ol 750 TL freebet kazan! | FILTER_SPAM | Aggressive bonus claim. |
| 135 | SPAM_BAHIS | Maca oyna, kazancini katla, iddaa burada daha avantajli. | FILTER_SPAM | Sports betting ad. |
| 136 | SPAM_BAHIS | Kupon yap, oran kovala, bonusu kap. | FILTER_SPAM | Multiple betting cues. |
| 137 | SPAM_BAHIS | Casino adresimiz guncellendi, yeni link: tinyurl.com/abc | FILTER_SPAM | Gambling plus short link. |
| 138 | SPAM_BAHIS | Banko maclar burada, canli bahis keyfi seni bekliyor. | FILTER_SPAM | Strong gambling indicators. |
| 139 | SPAM_BAHIS | Freebet kodu ALKAZAN, ilk yatirima ozel. | FILTER_SPAM | Betting code and bonus. |
| 140 | SPAM_BAHIS | 500 TL deneme bonusu yatirimsiz, sadece bugun. | FILTER_SPAM | Common illegal gambling bait. |
| 141 | SPAM_BAHIS | Super oranlar acildi, galibiyete oyna. | FILTER_SPAM | Betting terminology. |
| 142 | SPAM_BAHIS | Mac tahmini ve kupon paylasimi icin bu adrese gel. | FILTER_SPAM | Sports betting recruitment. |
| 143 | SPAM_BAHIS | Cepte kazanc, bahis panelin hazir. | FILTER_SPAM | Gambling invitation. |
| 144 | SPAM_BAHIS | Jackpot seni bekliyor, slotta bugun sansli gunun. | FILTER_SPAM | Casino spam. |
| 145 | SPAM_BAHIS | Deneme bonusu verdik, hesabina giris yap. | FILTER_SPAM | Typical bahis lure. |
| 146 | SPAM_BAHIS | Bahis promosyonu: arkadasini getir, bonus katla. | FILTER_SPAM | Promotional gambling. |
| 147 | SPAM_BAHIS | Canli casino ve iddaa tek adreste. | FILTER_SPAM | Combined gambling keywords. |
| 148 | SPAM_BAHIS | Hemen kayit, cevrimsiz bonus, hizli cekim! | FILTER_SPAM | High-confidence spam phrases. |
| 149 | SPAM_BAHIS | Freespin tanimlandi, slot giris linki burada. | FILTER_SPAM | Gambling spam with access lure. |
| 150 | SPAM_BAHIS | Yasadisi bahis hattindan mesaj: kuponun hazir. | FILTER_SPAM | Explicit spam context. |
| 151 | SCAM | Hesabiniz askiya alindi. Acmak icin linke tiklayin: pay-guvenli.co | REVIEW_SUSPICIOUS | Strong scam phrase; suspicious domain; no verified brand. |
| 152 | SCAM | Kargonuz teslim edilemedi. 12,50 TL odeme icin hemen giris yapin: ptt-odeme.top | REVIEW_SUSPICIOUS | Fake cargo fee trap. |
| 153 | SCAM | Odul kazandiniz! 20.000 TL almak icin bilgilerinizi dogrulayin. | FILTER_SPAM | Prize scam language. |
| 154 | SCAM | Banka hesabiniz blokelendi, sifrenizi guncelleyin: akbnk-guvenlik.net | FILTER_SPAM | Fake bank urgency with lookalike domain. |
| 155 | SCAM | Gonderiniz gumrukte. Teslim icin kart bilgisi gerek: cargo-fast.click | FILTER_SPAM | Credential/payment phishing. |
| 156 | SCAM | Son uyari: e-faturaniz iptal edilecek, hemen tiklayin. | REVIEW_SUSPICIOUS | Threat plus click bait, but less explicit brand. |
| 157 | SCAM | Devlet yardimi odemeniz hazir, IBAN giriniz. | FILTER_SPAM | Official impersonation with money lure. |
| 158 | SCAM | Adiniza icra dosyasi acildi, detay icin bu linke tiklayin. | REVIEW_SUSPICIOUS | Common urgency scam, legal threat. |
| 159 | SCAM | Hesabinizdan supheli para cikisi oldu, linkten islemi iptal edin. | FILTER_SPAM | Fake fraud alert with malicious CTA. |
| 160 | SCAM | PTT teslim ucreti odemesi bekliyor, gecikmemesi icin hemen acin. | REVIEW_SUSPICIOUS | Cargo impersonation likely phishing. |
| 161 | SCAM | T.C. yardim fonundan 15.000 TL yardim hakki kazandiniz. | FILTER_SPAM | Unrealistic reward/official impersonation. |
| 162 | SCAM | Kredi kartiniz kapatilacak, aktivasyon icin tiklayin. | FILTER_SPAM | Bank-like phishing pattern. |
| 163 | SCAM | E-Devlet hesabiniza giris yapilamadi. Kimliginizi dogrulayin: tr-giris.live | FILTER_SPAM | Official impersonation with fake domain. |
| 164 | SCAM | Paketiniz iade edilmemesi icin adres onayi yapin. | REVIEW_SUSPICIOUS | Delivery impersonation but no trusted domain. |
| 165 | SCAM | Cekilis sonucu iPhone kazandiniz, teslim icin formu doldurun. | FILTER_SPAM | Prize scam. |
| 166 | SCAM | Geciken HGS borcunuz icin icra baslatilacak. Hemen odeme yapin. | REVIEW_SUSPICIOUS | Fear-based toll scam. |
| 167 | SCAM | Hastane provizyonunuz reddedildi, kartinizdan tekrar cekim icin giris yapin. | REVIEW_SUSPICIOUS | Healthcare impersonation for payment. |
| 168 | SCAM | Ziraat musteri hizmetleri: onay icin bu baglantidan sifrenizi girin. | FILTER_SPAM | Brand phishing request. |
| 169 | SCAM | Yurtici teslim kodu gecerli degil, yeni kod almak icin linke tiklayin. | REVIEW_SUSPICIOUS | Impersonation with suspicious action. |
| 170 | SCAM | Vergi iadeniz hazir. Banka bilgilerinizi guncelleyin. | FILTER_SPAM | Government-finance phishing. |
| 171 | MIXED | Win 5000TL now, freebet bonus active, hemen join ol. | FILTER_SPAM | Mixed Turkish-English gambling spam. |
| 172 | MIXED | Cargo update: package on hold, pay 9.99 TL now at fast-ptt.cc | REVIEW_SUSPICIOUS | Fake cargo fee in mixed language. |
| 173 | MIXED | Bank security alert! login code 551200 if this was you ignore. | ALLOW_CRITICAL | Security login code despite English wording. |
| 174 | MIXED | Limited promo: yeni uyelere %30 indirim, detay uygulamada. | FILTER_PROMOTIONAL | Generic harmless ad, no scam content. |
| 175 | MIXED | Cashback bonus + casino vip access. Register simdi. | FILTER_SPAM | Casino plus bonus lure. |
| 176 | MIXED | Account locked, tekrar acmak icin click here. | REVIEW_SUSPICIOUS | Suspicious but generic account-lock scam. |
| 177 | MIXED | Delivery code 8832. Courier kapida. | ALLOW_TRANSACTIONAL | Delivery verification language. |
| 178 | MIXED | Flash sale basladi, only today free shipping. | FILTER_PROMOTIONAL | Marketing-only message. |
| 179 | MIXED | Free spin active, son 2 saat, cashout hizli. | FILTER_SPAM | Gambling terminology. |
| 180 | MIXED | Appointment reminder: yarin 15:20 dis hekimi randevunuz var. | ALLOW_TRANSACTIONAL | Benign medical reminder. |
| 181 | ADVERSARIAL | b@h!s firsati, 3000 tl bonu$ seni bekliyor | FILTER_SPAM | Obfuscated bahis and bonus. |
| 182 | ADVERSARIAL | b a h i s paneli acildi, h e m e n g i r | FILTER_SPAM | Spaced betting words. |
| 183 | ADVERSARIAL | i.d.d.a.a sevenlere oran dopingi | FILTER_SPAM | Punctuation-split betting keyword. |
| 184 | ADVERSARIAL | fr33bet kodun hazir, t1kla gel | FILTER_SPAM | Leetspeak freebet lure. |
| 185 | ADVERSARIAL | d0grulama k0du 551299, bunu kimseyle paylasmayin | ALLOW_CRITICAL | OTP with numeric substitutions must remain safe. |
| 186 | ADVERSARIAL | karg0nuz dag1t1ma c1kt1 | ALLOW_TRANSACTIONAL | Cargo text with substitutions should stay safe. |
| 187 | ADVERSARIAL | h3sabiniz a$kiya alindi, l!nke tiklayin | REVIEW_SUSPICIOUS | Obfuscated scam phrasing. |
| 188 | ADVERSARIAL | tek kullanimlik s!fre: 441100 | ALLOW_CRITICAL | OTP obfuscated but clearly safe. |
| 189 | ADVERSARIAL | c@sin0 g1r1s linki guncel | FILTER_SPAM | Casino obfuscation. |
| 190 | ADVERSARIAL | e d e v l e t giris kodunuz 227733 | ALLOW_CRITICAL | Spaced official OTP should remain safe. |
| 191 | SHORT | Kodunuz 5512 | ALLOW_CRITICAL | Extremely short but classic OTP pattern. |
| 192 | SHORT | Merhaba, musait misin? | ALLOW_NORMAL | Personal harmless content. |
| 193 | SHORT | Bonus var. | REVIEW_SUSPICIOUS | Ambiguous risky promotional bait; not enough for direct filter. |
| 194 | SHORT | Paket geldi. | ALLOW_NORMAL | Harmless short text, insufficient structure. |
| 195 | SHORT | Tikla kazan | REVIEW_SUSPICIOUS | Suspicious CTA without full scam certainty. |
| 196 | LONG | Sayin musterimiz, Garanti BBVA kartinizla 22.03.2026 saat 13:44'te 1.925,55 TL tutarinda internet harcamasi yapilmistir. Islem size ait degilse uygulamadan kartinizi kapatiniz. | ALLOW_CRITICAL | Long-form detailed bank fraud-safe alert. |
| 197 | LONG | Trendyol siparisinizin teslimati icin kuryemiz bugun 18:00-22:00 arasinda adresinize gelecektir. Teslim kodunuz 4410 olup sadece teslim aninda paylasiniz. | ALLOW_TRANSACTIONAL | Long but clearly transactional. |
| 198 | LONG | Tebrikler, sistemimiz sizi ozel uye olarak secti. Hemen kayit olup 10.000 TL deneme bonusu, cevrimsiz freebet ve tum maclarda yuksek oran avantajindan yararlanin. | FILTER_SPAM | Long-form bahis promotion. |
| 199 | LONG | Sayin kullanici, kargonuz gonderi merkezinde beklemektedir. Kimlik ve kart onayi icin asagidaki baglantidan 15 TL odeme yapmaniz gerekmektedir, aksi halde iade islemi baslayacaktir. | FILTER_SPAM | Cargo impersonation with payment demand. |
| 200 | LONG | Bilgilendirme: MHRS uzerinden olusturulan 24.03.2026 tarihli goz poliklinigi randevunuz icin 20 dakika once basvuru bankosunda bulunmaniz gerekmektedir. | ALLOW_TRANSACTIONAL | Detailed official healthcare reminder. |

## Dataset Notes

- Examples are synthetic and intended for QA, not real user data.
- The dataset is intentionally conservative: uncertain scams often map to `REVIEW_SUSPICIOUS` instead of direct filter.
- Any future rule change should add or update examples here before code is modified.
