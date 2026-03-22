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
        .init(name: "turkish_sifre", input: "Şifre", expectedComparableFragments: ["sifre"]),
        .init(name: "turkish_iddaa", input: "ıddaa", expectedComparableFragments: ["iddaa"]),
        .init(name: "spacing_bahis", input: "b a h i s", expectedComparableFragments: ["bahis"]),
        .init(name: "leet_bahis", input: "b@his", expectedComparableFragments: ["bahis"]),
        .init(name: "leet_freebet", input: "fr33bet", expectedComparableFragments: ["freebet"]),
        .init(name: "leet_sifre", input: "ş1fre", expectedComparableFragments: ["sifre"]),
        .init(name: "punctuation_iddaa", input: "i.d.d.a.a", expectedComparableFragments: ["iddaa"]),
        .init(name: "spaces_otp", input: "o n a y k o d u", expectedComparableFragments: ["onaykodu"]),
        .init(name: "zero_width_like", input: "ba\u{200B}his", expectedComparableFragments: ["bahis"]),
        .init(name: "mixed_case", input: "OnAy KoDu", expectedComparableFragments: ["onay kodu"]),
        .init(name: "cargo_diacritic", input: "dağıtıma çıktı", expectedComparableFragments: ["dagitima cikti"]),
        .init(name: "payment_phrase", input: "ödemeniz alınmıştır", expectedComparableFragments: ["odemeniz alinmistir"]),
        .init(name: "collapse_spaces", input: "dogrulama    kodu", expectedComparableFragments: ["dogrulama kodu"]),
        .init(name: "euro_symbol", input: "öd€me", expectedComparableFragments: ["odeme"]),
        .init(name: "casino_leet", input: "cas1no", expectedComparableFragments: ["casino"])
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
        .init(name: "critical_not_spam_with_bonus_word", input: .init(sender: "Banka", body: "Onay kodunuz 551122. Bonus puan bilginiz uygulamada."), expectedCategory: .allowCritical)
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
        .init(name: "utility_notice", input: .init(sender: nil, body: "Paketinizin suresi yarin doluyor."), expectedCategory: .allowTransactional)
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
        .init(name: "blacklist_term_spam", input: .init(sender: "Spam Sender", body: "Kampanya aktif."), expectedCategory: .filterSpam)
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
        .init(name: "otp_account_lock", input: .init(sender: nil, body: "Onay kodunuz 771204. Hesabiniz askiya alindi, hemen acin."), expectedCategory: .reviewSuspicious)
    ]
}
