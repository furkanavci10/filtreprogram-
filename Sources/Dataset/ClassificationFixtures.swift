import Foundation
import MessageFilteringDomain

public struct NormalizationFixture: Sendable {
    public let name: String
    public let input: String
    public let expectedComparableFragments: [String]

    public init(name: String, input: String, expectedComparableFragments: [String]) {
        self.name = name
        self.input = input
        self.expectedComparableFragments = expectedComparableFragments
    }
}

public struct ClassificationFixture: Sendable {
    public let name: String
    public let input: ClassificationInput
    public let expectedCategory: MessageClassificationCategory

    public init(name: String, input: ClassificationInput, expectedCategory: MessageClassificationCategory) {
        self.name = name
        self.input = input
        self.expectedCategory = expectedCategory
    }
}

public enum ClassificationFixtures {
    public static let normalization: [NormalizationFixture] = [
        .init(name: "turkish_sifre", input: "\u{15E}ifre", expectedComparableFragments: ["sifre"]),
        .init(name: "turkish_iddaa", input: "\u{131}ddaa", expectedComparableFragments: ["iddaa"]),
        .init(name: "spacing_bahis", input: "b a h i s", expectedComparableFragments: ["bahis"]),
        .init(name: "spacing_iddaa", input: "i d d a a", expectedComparableFragments: ["iddaa"]),
        .init(name: "leet_bahis", input: "b@h!s", expectedComparableFragments: ["bahis"]),
        .init(name: "leet_freebet", input: "fr33bet", expectedComparableFragments: ["freebet"]),
        .init(name: "leet_sifre", input: "\u{15F}1fre", expectedComparableFragments: ["sifre"]),
        .init(name: "punctuation_iddaa", input: "i.d.d.a.a", expectedComparableFragments: ["iddaa"]),
        .init(name: "hyphen_bahis", input: "ba-his", expectedComparableFragments: ["bahis"]),
        .init(name: "dot_bahis", input: "ba.his", expectedComparableFragments: ["bahis"]),
        .init(name: "underscore_bahis", input: "ba_hi_s", expectedComparableFragments: ["bahis"]),
        .init(name: "zero_width_like", input: "ba\u{200B}his", expectedComparableFragments: ["bahis"]),
        .init(name: "mixed_case", input: "OnAy KoDu", expectedComparableFragments: ["onay kodu"]),
        .init(name: "cargo_diacritic", input: "da\u{11F}\u{131}t\u{131}ma \u{E7}\u{131}kt\u{131}", expectedComparableFragments: ["dagitima cikti"]),
        .init(name: "payment_phrase", input: "\u{F6}demeniz al\u{131}nm\u{131}\u{15F}t\u{131}r", expectedComparableFragments: ["odemeniz alinmistir"]),
        .init(name: "collapse_spaces", input: "dogrulama    kodu", expectedComparableFragments: ["dogrulama kodu"]),
        .init(name: "euro_symbol", input: "\u{F6}d\u{20AC}me", expectedComparableFragments: ["odeme"]),
        .init(name: "casino_leet", input: "cas1no", expectedComparableFragments: ["casino"]),
        .init(name: "phishing_cta_obfuscated", input: "l!nke t!klay!n", expectedComparableFragments: ["linke tiklayin"]),
        .init(name: "fake_cargo_spacing", input: "kar go nuz bekle mede", expectedComparableFragments: ["kargonuz"]),
        .init(name: "repeated_bahis_noise", input: "baaahiiis", expectedComparableFragments: ["baahiis", "bahis"]),
        .init(name: "repeated_freebet_noise", input: "freeeeebet", expectedComparableFragments: ["freeebet", "freebet"]),
        .init(name: "invisible_otp", input: "onay\u{2060}kodu", expectedComparableFragments: ["onaykodu"]),
        .init(name: "mixed_digit_iddaa", input: "1ddaa", expectedComparableFragments: ["iddaa"]),
        .init(name: "mixed_digit_phishing", input: "d0grulayin", expectedComparableFragments: ["dogrulayin"]),
        .init(name: "bank_word_safe", input: "şüpheli işlem", expectedComparableFragments: ["supheli islem"]),
        .init(name: "otp_readable_safe", input: "tek kullanımlık şifre", expectedComparableFragments: ["tek kullanımlik sifre"]),
        .init(name: "fake_cargo_punctuation", input: "kargo-nuz beklemede", expectedComparableFragments: ["kargo", "beklemede"]),
        .init(name: "bonus_obfuscated", input: "bonu$s", expectedComparableFragments: ["bonus"]),
        .init(name: "bahis_plus_digit", input: "b4his", expectedComparableFragments: ["bahis"]),
        .init(name: "cta_plus_zero", input: "t0kla", expectedComparableFragments: ["tokla"]),
        .init(name: "free_spin_spaced", input: "free spin", expectedComparableFragments: ["free spin", "freespin"]),
        .init(name: "bank_link_spacing", input: "lin ke ti klayin", expectedComparableFragments: ["linke tiklayin"]),
        .init(name: "otp_zero_width", input: "doğrulama\u{200D}kodu", expectedComparableFragments: ["dogrulamakodu", "dogrulama kodu"]),
        .init(name: "cargo_underscore_variant", input: "kar_go_nuz", expectedComparableFragments: ["kargonuz"])
    ]

    public static let critical: [ClassificationFixture] = [
        .init(name: "bank_otp_1", input: .init(sender: "Akbank", body: "Akbank: Mobil onay kodunuz 551122. Kimseyle paylasmayin."), expectedCategory: .allowCritical),
        .init(name: "bank_otp_2", input: .init(sender: "Garanti", body: "Dogrulama kodunuz 771204. Bu kodu kimseyle paylasmayin."), expectedCategory: .allowCritical),
        .init(name: "bank_spending_1", input: .init(sender: "TEB", body: "Kartinizla 320 TL harcama yapildi."), expectedCategory: .allowCritical),
        .init(name: "bank_spending_2", input: .init(sender: "Akbank", body: "Kartinizla 59,99 TL Spotify harcamaniz gerceklesti."), expectedCategory: .allowCritical),
        .init(name: "account_access_1", input: .init(sender: "Is Bankasi", body: "Hesabiniza giris denemeniz icin onay kodunuz 482911."), expectedCategory: .allowCritical),
        .init(name: "account_access_2", input: .init(sender: "Garanti", body: "Yeni cihaz tanimlama kodunuz 232323."), expectedCategory: .allowCritical),
        .init(name: "suspicious_transaction_notice", input: .init(sender: "Akbank", body: "Supheli islem tespit edildi. Mobil onay kodunuz 903144."), expectedCategory: .allowCritical),
        .init(name: "payment_confirmation", input: .init(sender: "Papara", body: "Odemeniz alinmistir. Islem onaylandi."), expectedCategory: .allowCritical),
        .init(name: "telecom_login_code", input: .init(sender: "Turkcell", body: "Tek kullanimlik kodunuz 202760."), expectedCategory: .allowCritical),
        .init(name: "government_code", input: .init(sender: "e-Devlet", body: "Onay kodu 710002."), expectedCategory: .allowCritical),
        .init(name: "health_login_code", input: .init(sender: "MHRS", body: "Giris kodunuz 300600."), expectedCategory: .allowCritical),
        .init(name: "obfuscated_otp", input: .init(sender: nil, body: "d0grulama k0du 551299, bunu kimseyle paylasmayin"), expectedCategory: .allowCritical),
        .init(name: "otp_with_noise", input: .init(sender: nil, body: "Onay kodunuz 551122, hemen giris yapin."), expectedCategory: .allowCritical),
        .init(name: "bank_transfer", input: .init(sender: "Ziraat", body: "FAST isleminiz tamamlandi."), expectedCategory: .allowCritical),
        .init(name: "password_reset", input: .init(sender: "Amazon TR", body: "Sifre yenileme kodunuz 660821."), expectedCategory: .allowCritical),
        .init(name: "device_approval", input: .init(sender: "Odeabank", body: "Yeni cihaz tanimlama kodunuz 232323."), expectedCategory: .allowCritical),
        .init(name: "payment_amount", input: .init(sender: "Garanti", body: "1.250 TL tutarinda odemeniz alinmistir."), expectedCategory: .allowCritical),
        .init(name: "security_phrase", input: .init(sender: nil, body: "Bu kodu kimseyle paylasmayin. Onay kodunuz 123456."), expectedCategory: .allowCritical),
        .init(name: "bank_conflict_weak_noise", input: .init(sender: "Akbank", body: "Akbank onay kodunuz 551122. Hemen kontrol edin."), expectedCategory: .allowCritical),
        .init(name: "critical_not_spam_with_bonus_word", input: .init(sender: "Banka", body: "Onay kodunuz 551122. Bonus puan bilginiz uygulamada."), expectedCategory: .allowCritical),
        .init(name: "bank_login_alert_1", input: .init(sender: "Yapi Kredi", body: "Mobil bankacilik girisiniz onaylandi."), expectedCategory: .allowCritical),
        .init(name: "bank_login_alert_2", input: .init(sender: "QNB", body: "Internet subesi girisiniz icin dogrulama kodu 889900."), expectedCategory: .allowCritical),
        .init(name: "bank_login_alert_3", input: .init(sender: "Enpara", body: "Yeni cihaz girisi icin onay kodunuz 224466."), expectedCategory: .allowCritical),
        .init(name: "card_spending_alert_3", input: .init(sender: "Garanti BBVA", body: "Kartinizla 1.149 TL internet harcamasi yapildi."), expectedCategory: .allowCritical),
        .init(name: "card_spending_alert_4", input: .init(sender: "Ziraat", body: "Kartinizla 89,90 TL odeme yapildi. Islem size ait degilse arayin."), expectedCategory: .allowCritical),
        .init(name: "suspicious_transaction_2", input: .init(sender: "VakifBank", body: "Supheli islem bildirimi icin onay kodunuz 441199."), expectedCategory: .allowCritical),
        .init(name: "suspicious_transaction_3", input: .init(sender: "Halkbank", body: "Supheli para cikisi bildirimi icin mobil onay kodu 202303."), expectedCategory: .allowCritical),
        .init(name: "payment_confirmation_2", input: .init(sender: "Papara", body: "1.250 TL odemeniz basariyla tamamlandi."), expectedCategory: .allowCritical),
        .init(name: "payment_confirmation_3", input: .init(sender: "Turkcell", body: "Mobil odeme isleminiz 129 TL icin gerceklesti."), expectedCategory: .allowCritical),
        .init(name: "password_reset_2", input: .init(sender: "Netflix", body: "Sifre yenileme kodunuz 551908."), expectedCategory: .allowCritical),
        .init(name: "password_reset_3", input: .init(sender: "Amazon", body: "Hesabiniz icin dogrulama kodu 774411."), expectedCategory: .allowCritical),
        .init(name: "otp_short_form_2", input: .init(sender: nil, body: "Kodunuz 5512"), expectedCategory: .allowCritical),
        .init(name: "otp_short_form_3", input: .init(sender: nil, body: "Onay kodu: 447711"), expectedCategory: .allowCritical),
        .init(name: "government_login_2", input: .init(sender: "e-Nabiz", body: "Giris kodunuz 441190."), expectedCategory: .allowCritical),
        .init(name: "government_login_3", input: .init(sender: "Gelir Idaresi", body: "Dijital vergi dairesi onay kodunuz 700145."), expectedCategory: .allowCritical),
        .init(name: "telecom_security_2", input: .init(sender: "Vodafone", body: "Vodafone Yanimda onay kodu 909080."), expectedCategory: .allowCritical),
        .init(name: "telecom_security_3", input: .init(sender: "Turk Telekom", body: "Hesap giris kodunuz 551008."), expectedCategory: .allowCritical),
        .init(name: "device_approval_2", input: .init(sender: "Garanti", body: "Yeni cihaz onayi icin kodunuz 414141."), expectedCategory: .allowCritical),
        .init(name: "bank_security_phrase_2", input: .init(sender: "Akbank", body: "Bu kodu kimseyle paylasmayin. Mobil onay kodunuz 782211."), expectedCategory: .allowCritical),
        .init(name: "fraud_hotline_warning", input: .init(sender: "Is Bankasi", body: "Kartinizla 2.450 TL odeme yapildi. Bilginiz disindaysa arayin."), expectedCategory: .allowCritical)
    ]

    public static let transactional: [ClassificationFixture] = [
        .init(name: "cargo_tracking", input: .init(sender: "Aras Kargo", body: "Kargonuz dagitima cikarilmistir. Takip no 438219."), expectedCategory: .allowTransactional),
        .init(name: "cargo_delivered", input: .init(sender: "Yurtici", body: "Kargonuz teslim edildi."), expectedCategory: .allowTransactional),
        .init(name: "cargo_delivery_code", input: .init(sender: "Trendyol Express", body: "Kurye kapida. Teslim kodunuz 4412."), expectedCategory: .allowTransactional),
        .init(name: "order_shipped", input: .init(sender: "Hepsijet", body: "Siparisiniz kuryeye verildi."), expectedCategory: .allowTransactional),
        .init(name: "order_return", input: .init(sender: "Hepsiburada", body: "Iade talebiniz alinmistir."), expectedCategory: .allowTransactional),
        .init(name: "appointment_1", input: .init(sender: "MHRS", body: "Randevunuz yarin 13:45 icin onaylanmistir."), expectedCategory: .allowTransactional),
        .init(name: "appointment_2", input: .init(sender: "Acibadem", body: "Muayene randevunuz 25.03.2026 09:15."), expectedCategory: .allowTransactional),
        .init(name: "hospital_result", input: .init(sender: "E-Nabiz", body: "Laboratuvar sonuclariniz hazir."), expectedCategory: .allowTransactional),
        .init(name: "billing_1", input: .init(sender: "Turkcell", body: "Mart faturaniz 420,50 TL, son odeme tarihi 28.03.2026."), expectedCategory: .allowTransactional),
        .init(name: "billing_2", input: .init(sender: "Turk Telekom", body: "Faturaniz odendi, tesekkur ederiz."), expectedCategory: .allowTransactional),
        .init(name: "telecom_notice", input: .init(sender: "Vodafone Net", body: "Ariza kaydiniz acilmistir."), expectedCategory: .allowTransactional),
        .init(name: "reservation", input: .init(sender: "Pegasus", body: "Rezervasyonunuz tamamlandi. PNR AB12CD."), expectedCategory: .allowTransactional),
        .init(name: "invoice", input: .init(sender: "Watsons", body: "Siparisiniz icin e fatura olusturuldu."), expectedCategory: .allowTransactional),
        .init(name: "package_ready", input: .init(sender: "Teknosa", body: "Siparisiniz magaza teslimine hazirdir."), expectedCategory: .allowTransactional),
        .init(name: "utility_notice", input: .init(sender: nil, body: "Paketinizin suresi yarin doluyor."), expectedCategory: .allowTransactional),
        .init(name: "cargo_subeye_ulasti", input: .init(sender: "MNG Kargo", body: "902134 takip nolu paketiniz subeye ulasmistir."), expectedCategory: .allowTransactional),
        .init(name: "cargo_transfer", input: .init(sender: "HepsiJET", body: "Paketiniz transfer merkezine ulasti."), expectedCategory: .allowTransactional),
        .init(name: "cargo_address_missed", input: .init(sender: "Yurtici Kargo", body: "Adresinizde bulunamadiniz. Gonderi subeden alinabilir."), expectedCategory: .allowTransactional),
        .init(name: "cargo_delivery_window", input: .init(sender: "Trendyol Express", body: "Siparisiniz bugun 18:00-22:00 arasinda teslim edilecektir."), expectedCategory: .allowTransactional),
        .init(name: "cargo_partial_delivery", input: .init(sender: "Aras Kargo", body: "3 parcali gonderinizin 1 parcasi teslim edilmistir."), expectedCategory: .allowTransactional),
        .init(name: "appointment_hospital_3", input: .init(sender: "Memorial", body: "MR sonucunuz sisteme yuklenmistir."), expectedCategory: .allowTransactional),
        .init(name: "appointment_hospital_4", input: .init(sender: "Medicana", body: "Tahlil sonuclariniz cikmistir."), expectedCategory: .allowTransactional),
        .init(name: "appointment_hospital_5", input: .init(sender: "Acibadem", body: "Kontrol randevunuz 26 Mart 11:00."), expectedCategory: .allowTransactional),
        .init(name: "telecom_billing_3", input: .init(sender: "Vodafone", body: "10GB ek paketiniz tanimlandi."), expectedCategory: .allowTransactional),
        .init(name: "telecom_billing_4", input: .init(sender: "Turk Telekom", body: "Taahhut bitis tarihiniz yaklasiyor."), expectedCategory: .allowTransactional),
        .init(name: "telecom_billing_5", input: .init(sender: "Bimcell", body: "Paketinizin suresi yarin doluyor."), expectedCategory: .allowTransactional),
        .init(name: "telecom_service_visit", input: .init(sender: "Superonline", body: "Ariza ekibimiz 16:00-18:00 arasinda gelecektir."), expectedCategory: .allowTransactional),
        .init(name: "ecommerce_delivery_2", input: .init(sender: "Amazon", body: "249 TL tutarli siparisiniz teslim edildi."), expectedCategory: .allowTransactional),
        .init(name: "ecommerce_delivery_3", input: .init(sender: "Getir", body: "189 TL odemeniz alindi, siparisiniz hazirlaniyor."), expectedCategory: .allowTransactional),
        .init(name: "ecommerce_delivery_4", input: .init(sender: "Yemeksepeti", body: "Siparisiniz restoranda hazirlaniyor."), expectedCategory: .allowTransactional),
        .init(name: "ecommerce_delivery_5", input: .init(sender: "Migros Hemen", body: "Siparisiniz yola cikti."), expectedCategory: .allowTransactional),
        .init(name: "ecommerce_invoice_2", input: .init(sender: "Gratis", body: "Iadeniz 3 gun icinde yatacaktir."), expectedCategory: .allowTransactional),
        .init(name: "government_notice_2", input: .init(sender: "NVI", body: "Kimlik randevunuz 24.03.2026 10:30 tarihinde olusturulmustur."), expectedCategory: .allowTransactional),
        .init(name: "government_notice_3", input: .init(sender: "SGK", body: "Provizyon bilgilendirmeniz olusturuldu."), expectedCategory: .allowTransactional),
        .init(name: "official_document_ready", input: .init(sender: "e-Devlet", body: "Adli sicil belgeniz hazirdir."), expectedCategory: .allowTransactional)
    ]

    public static let spam: [ClassificationFixture] = [
        .init(name: "bahis_1", input: .init(sender: nil, body: "Bahis hesabini ac, 5000 TL deneme bonusu hemen seninle."), expectedCategory: .filterSpam),
        .init(name: "bahis_2", input: .init(sender: nil, body: "iddaa severlere ozel freebet 300 TL. Kayit ol kazan."), expectedCategory: .filterSpam),
        .init(name: "bahis_3", input: .init(sender: nil, body: "Bugun mac oranlari uctu, kuponunu simdi yap."), expectedCategory: .filterSpam),
        .init(name: "casino_1", input: .init(sender: nil, body: "Casino vip girisiniz acildi, yatirimsiz bonus icin tikla."), expectedCategory: .filterSpam),
        .init(name: "casino_2", input: .init(sender: nil, body: "Slot ve jackpot oyuncularina 250 free spin."), expectedCategory: .filterSpam),
        .init(name: "bonus_1", input: .init(sender: nil, body: "Yatirim bonusu 100%, yeni uyelere ozel bahis kampanyasi."), expectedCategory: .filterSpam),
        .init(name: "bonus_2", input: .init(sender: nil, body: "Hemen uye ol 750 TL freebet kazan."), expectedCategory: .filterSpam),
        .init(name: "obfuscated_bahis_1", input: .init(sender: nil, body: "b@h!s paneli acildi, fr33bet kodu hazir."), expectedCategory: .filterSpam),
        .init(name: "obfuscated_bahis_2", input: .init(sender: nil, body: "b a h i s firsati, bonus burada."), expectedCategory: .filterSpam),
        .init(name: "shortlink_spam", input: .init(sender: nil, body: "Casino adresimiz guncellendi, yeni link tinyurl.com/abc"), expectedCategory: .filterSpam),
        .init(name: "promo_1", input: .init(sender: "Shop", body: "Flash sale basladi, yeni uyelere %30 indirim."), expectedCategory: .filterPromotional),
        .init(name: "promo_2", input: .init(sender: "Retail", body: "Ozel teklif: hemen kazan, kampanya sizi bekliyor."), expectedCategory: .filterPromotional),
        .init(name: "promo_3", input: .init(sender: "Market", body: "Indirim firsati ve ucretsiz kargo."), expectedCategory: .filterPromotional),
        .init(name: "scam_prize", input: .init(sender: nil, body: "Odul kazandiniz! 20.000 TL almak icin bilgilerinizi dogrulayin."), expectedCategory: .filterSpam),
        .init(name: "scam_government", input: .init(sender: nil, body: "Devlet yardimi odemeniz hazir, IBAN giriniz."), expectedCategory: .filterSpam),
        .init(name: "phishing_domain", input: .init(sender: nil, body: "Kartiniz kapatilacak, aktivasyon icin akbnk-guvenlik.net adresine gidin."), expectedCategory: .filterSpam),
        .init(name: "scam_account_lock", input: .init(sender: nil, body: "Hesabiniz askiya alindi, linke tiklayin."), expectedCategory: .filterSpam),
        .init(name: "betting_eng_mix", input: .init(sender: nil, body: "Win 5000TL now, freebet bonus active, hemen join ol."), expectedCategory: .filterSpam),
        .init(name: "cashout_spam", input: .init(sender: nil, body: "Free spin active, cashout hizli, son 2 saat."), expectedCategory: .filterSpam),
        .init(name: "blacklist_term_spam", input: .init(sender: "Spam Sender", body: "Kampanya aktif."), expectedCategory: .filterSpam),
        .init(name: "bahis_4", input: .init(sender: nil, body: "Oranlar burada, kuponunu simdi yap, kazanmaya basla."), expectedCategory: .filterSpam),
        .init(name: "bahis_5", input: .init(sender: nil, body: "Canli bahis keyfi seni bekliyor, banko maclar burada."), expectedCategory: .filterSpam),
        .init(name: "bahis_6", input: .init(sender: nil, body: "Kupon yap, oran kovala, bonusu kap."), expectedCategory: .filterSpam),
        .init(name: "bahis_7", input: .init(sender: nil, body: "Hemen kayit, cevrimsiz bonus, hizli cekim."), expectedCategory: .filterSpam),
        .init(name: "bahis_obfuscated_3", input: .init(sender: nil, body: "b a h i s paneli acildi, h e m e n g i r"), expectedCategory: .filterSpam),
        .init(name: "bahis_obfuscated_4", input: .init(sender: nil, body: "i.d.d.a.a sevenlere oran dopingi"), expectedCategory: .filterSpam),
        .init(name: "bahis_obfuscated_5", input: .init(sender: nil, body: "fr33bet kodun hazir, t1kla gel"), expectedCategory: .filterSpam),
        .init(name: "casino_3", input: .init(sender: nil, body: "Jackpot seni bekliyor, slotta bugun sansli gunun."), expectedCategory: .filterSpam),
        .init(name: "casino_4", input: .init(sender: nil, body: "Canli casino ve iddaa tek adreste."), expectedCategory: .filterSpam),
        .init(name: "casino_5", input: .init(sender: nil, body: "Casino adresimiz guncellendi, yeni link bit.ly/x7"), expectedCategory: .filterSpam),
        .init(name: "prize_scam_2", input: .init(sender: nil, body: "Cekilis sonucu iPhone kazandiniz, teslim icin formu doldurun."), expectedCategory: .filterSpam),
        .init(name: "prize_scam_3", input: .init(sender: nil, body: "Hediyeniz hazir, para odulu icin hemen tiklayin."), expectedCategory: .filterSpam),
        .init(name: "phishing_bank_2", input: .init(sender: nil, body: "Banka hesabiniz blokelendi, sifrenizi guncelleyin: garanti-onay.net"), expectedCategory: .filterSpam),
        .init(name: "phishing_bank_3", input: .init(sender: nil, body: "Ziraat musteri hizmetleri: sifrenizi girin ve hesabinizi dogrulayin."), expectedCategory: .filterSpam),
        .init(name: "phishing_cargo_2", input: .init(sender: nil, body: "Kargonuz beklemede, odeme icin cargo-fast.click adresine gidin."), expectedCategory: .filterSpam),
        .init(name: "phishing_cargo_3", input: .init(sender: nil, body: "PTT teslim ucreti odemesi bekliyor, hemen acin."), expectedCategory: .filterSpam),
        .init(name: "mixed_tr_en_spam_2", input: .init(sender: nil, body: "Cashback bonus + casino vip access. Register simdi."), expectedCategory: .filterSpam),
        .init(name: "mixed_tr_en_spam_3", input: .init(sender: nil, body: "Delivery update? no, freebet active now, join ol."), expectedCategory: .filterSpam),
        .init(name: "legal_threat_spam_2", input: .init(sender: nil, body: "Vergi iadeniz hazir. Banka bilgilerinizi guncelleyin."), expectedCategory: .filterSpam),
        .init(name: "legal_threat_spam_3", input: .init(sender: nil, body: "Kredi kartiniz kapatilacak, aktivasyon icin tiklayin."), expectedCategory: .filterSpam),
        .init(name: "urgent_fake_bank_mix", input: .init(sender: nil, body: "Account locked hemen click, sifrenizi girin."), expectedCategory: .filterSpam),
        .init(name: "urgent_fake_cargo_mix", input: .init(sender: nil, body: "Cargo update: package on hold, pay 9.99 TL now at fast-ptt.cc"), expectedCategory: .filterSpam),
        .init(name: "adult_like_spam", input: .init(sender: nil, body: "Gizli sohbet hatti aktif, hemen katil."), expectedCategory: .filterSpam),
        .init(name: "loan_scam", input: .init(sender: nil, body: "Hemen kredi cikti, bilgilerinizle dogrulayin."), expectedCategory: .filterSpam),
        .init(name: "promo_4", input: .init(sender: "Retail", body: "Kampanya basladi, ozel teklif sizi bekliyor."), expectedCategory: .filterPromotional)
    ]

    public static let conflict: [ClassificationFixture] = [
        .init(name: "fake_bank_1", input: .init(sender: nil, body: "Akbank hesabiniz bloke edildi. Sifrenizi guncellemek icin akbnk-guvenlik.net adresine girin."), expectedCategory: .reviewSuspicious),
        .init(name: "fake_bank_2", input: .init(sender: nil, body: "Garanti hesabiniz kapanacak. Linke tiklayip sifrenizi girin."), expectedCategory: .reviewSuspicious),
        .init(name: "fake_bank_3", input: .init(sender: nil, body: "Onay kodunuz 771204. Hesabinizi korumak icin linke tiklayip sifrenizi girin."), expectedCategory: .reviewSuspicious),
        .init(name: "fake_cargo_1", input: .init(sender: nil, body: "Kargonuz teslim edilemedi. 12,50 TL odeme icin ptt-odeme.top adresine girin."), expectedCategory: .reviewSuspicious),
        .init(name: "fake_cargo_2", input: .init(sender: nil, body: "Kargonuz beklemede, paketiniz iade olmamasi icin odeme yapin."), expectedCategory: .reviewSuspicious),
        .init(name: "fake_cargo_3", input: .init(sender: nil, body: "Yurtici teslim kodu gecerli degil, yeni kod almak icin linke tiklayin."), expectedCategory: .reviewSuspicious),
        .init(name: "otp_with_link", input: .init(sender: nil, body: "Dogrulama kodunuz 771204. Linke tiklayin."), expectedCategory: .reviewSuspicious),
        .init(name: "hospital_payment_trap", input: .init(sender: nil, body: "Hastane provizyonunuz reddedildi, kart bilgisi girin."), expectedCategory: .reviewSuspicious),
        .init(name: "debt_scam", input: .init(sender: nil, body: "Adiniza icra dosyasi acildi, detay icin linke tiklayin."), expectedCategory: .reviewSuspicious),
        .init(name: "official_like_scam", input: .init(sender: nil, body: "E-Devlet hesabiniza giris yapilamadi. Kimliginizi dogrulayin: tr-giris.live"), expectedCategory: .reviewSuspicious),
        .init(name: "cargo_payment_conflict", input: .init(sender: nil, body: "Kargonuz dagitima cikti, teslim icin 9 TL odeme yapin."), expectedCategory: .reviewSuspicious),
        .init(name: "otp_bonus_conflict", input: .init(sender: nil, body: "Onay kodunuz 551122, bonus icin tiklayin."), expectedCategory: .reviewSuspicious),
        .init(name: "bank_prize_conflict", input: .init(sender: nil, body: "Banka odulu kazandiniz, bilgilerinizi dogrulayin."), expectedCategory: .reviewSuspicious),
        .init(name: "bank_suspicious_domain", input: .init(sender: nil, body: "Ziraat musteri hizmetleri: onay icin bu baglantidan sifrenizi girin."), expectedCategory: .reviewSuspicious),
        .init(name: "otp_account_lock", input: .init(sender: nil, body: "Onay kodunuz 771204. Hesabiniz askiya alindi, hemen acin."), expectedCategory: .reviewSuspicious),
        .init(name: "bank_link_conflict_2", input: .init(sender: "Garanti", body: "Garanti onay kodunuz 551122. Hesabinizi korumak icin linke tiklayin."), expectedCategory: .reviewSuspicious),
        .init(name: "bank_link_conflict_3", input: .init(sender: "Ziraat", body: "Mobil onay kodunuz 224466. Sifrenizi girin."), expectedCategory: .reviewSuspicious),
        .init(name: "bank_fake_domain_conflict_2", input: .init(sender: "Akbank", body: "Akbank giris kodunuz 771204. akbnk-guvenlik.net adresine gidin."), expectedCategory: .reviewSuspicious),
        .init(name: "cargo_fee_conflict_2", input: .init(sender: nil, body: "Aras Kargo teslimatiniz icin 14 TL odeme yapin."), expectedCategory: .reviewSuspicious),
        .init(name: "cargo_fee_conflict_3", input: .init(sender: nil, body: "Paketiniz dagitim merkezinde, iade olmamasi icin kart bilgisi girin."), expectedCategory: .reviewSuspicious),
        .init(name: "cargo_tracking_link_conflict", input: .init(sender: nil, body: "Takip no 438219. Teslimat icin tinyurl.com/pay adresini acin."), expectedCategory: .reviewSuspicious),
        .init(name: "hospital_conflict_2", input: .init(sender: nil, body: "Randevunuz onaylandi, provizyon icin kart bilgisi girin."), expectedCategory: .reviewSuspicious),
        .init(name: "telecom_conflict_2", input: .init(sender: "Vodafone", body: "Paketiniz tanimlandi, hesabinizi acmak icin linke tiklayin."), expectedCategory: .reviewSuspicious),
        .init(name: "telecom_conflict_3", input: .init(sender: "Turkcell", body: "Faturaniz odendi. Hesabinizi guncellemek icin bu linke gidin."), expectedCategory: .reviewSuspicious),
        .init(name: "official_conflict_2", input: .init(sender: "e-Devlet", body: "Giris kodunuz 771204. Kimliginizi bu baglantidan dogrulayin."), expectedCategory: .reviewSuspicious),
        .init(name: "official_conflict_3", input: .init(sender: "MHRS", body: "Randevunuz onaylandi. Kart ile tekrar provizyon alin."), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_bank_bonus_conflict_2", input: .init(sender: "Banka", body: "Onay kodunuz 551122. Odul kazandiniz, tiklayin."), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_cargo_bonus_conflict", input: .init(sender: nil, body: "Kargonuz teslim edildi, bonus teslim icin formu doldurun."), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_otp_domain_conflict", input: .init(sender: nil, body: "Dogrulama kodu 889900. tr-giris.live adresine gidin."), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_bank_prize_conflict_3", input: .init(sender: nil, body: "Kartinizla odeme yapildi. Odul kazandiniz, bilgileri girin."), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_cargo_english_conflict", input: .init(sender: nil, body: "Delivery code 8832. Pay fee now."), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_official_english_conflict", input: .init(sender: nil, body: "e-Devlet login code 551122. verify now to unlock."), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_bank_sender_conflict", input: .init(sender: "Akbank", body: "Kartinizla harcama yapildi. Islemi iptal icin tinyurl.com/stop"), expectedCategory: .reviewSuspicious),
        .init(name: "mixed_cargo_sender_conflict", input: .init(sender: "Yurtici", body: "Gonderiniz dagitimda. Odemeyi tamamlamak icin linke tiklayin."), expectedCategory: .reviewSuspicious)
    ]
}
