# Turkish Edge Cases

This document lists 100 edge cases that must be considered in normalization, classification, and regression tests.

| ID | Edge Case | Example | Expected Handling |
| --- | --- | --- | --- |
| 001 | Turkish dotless i normalization | `sifre`, `sif re`, `sifresi` | Map variants for matching without losing raw text. |
| 002 | Bahis with symbol substitution | `b@his` | Detect as betting spam. |
| 003 | Bahis with exclamation substitution | `bah!s` | Detect as betting spam. |
| 004 | Bahis with spaces | `b a h i s` | Compact and detect. |
| 005 | Iddaa with punctuation | `i.d.d.a.a` | Strip punctuation and detect. |
| 006 | Freebet leetspeak | `fr33bet` | Detect after confusable normalization. |
| 007 | Bonus with currency sign | `bonu$` | Detect as bonus-related spam. |
| 008 | Hidden separator insertion | `ba-his`, `ba_his` | Ignore separators when appropriate. |
| 009 | Mixed Turkish-English gambling | `casino bonus hemen join` | Route to spam. |
| 010 | OTP with numeric replacements | `d0grulama k0du` | Preserve safe classification. |
| 011 | Cargo with numeric replacements | `karg0nuz dagitima cikti` | Preserve transactional classification. |
| 012 | Fake cargo plus fee | `kargonuz icin 9 TL odeme` | Route to review or spam. |
| 013 | Fake bank with link | `hesabiniz blokelendi, linke tiklayin` | Route to spam. |
| 014 | Real bank alert with amount | `kartinizla 320 TL odeme` | Critical allow. |
| 015 | Bank alert with merchant slang | `POS islem` | Critical allow if structure is sound. |
| 016 | OTP short form only | `Kodunuz 5512` | Critical allow. |
| 017 | OTP with no sender context | `Giris kodu: 331122` | Critical allow. |
| 018 | Cargo delivery code | `teslim kodunuz 4421` | Transactional allow, not mistaken for account OTP. |
| 019 | Appointment code | `muayene siraniz 18` | Transactional allow. |
| 020 | Promotional telecom gift | `5GB hediye tanimlandi` | Transactional allow if sender context is telecom. |
| 021 | Generic discount ad | `%20 indirim, detay uygulamada` | Promotional filter or allow normal depending on risk settings. |
| 022 | Harmless short text | `Neredesin` | Allow normal. |
| 023 | Suspicious short CTA | `Tikla kazan` | Review suspicious. |
| 024 | Ambiguous word bonus only | `bonus var` | Prefer review, not spam. |
| 025 | Bahis hidden inside long sentence | `bu gece mac severlere ozel oran` | Risk scoring should catch via betting terms. |
| 026 | Fake brand typo | `Trendy0l teslimat ucreti` | Review/spam due to spoofing. |
| 027 | Lookalike domain | `akbnk-guvenlik.net` | High phishing risk. |
| 028 | Safe official domain mention | `turkiye.gov.tr` | Positive safe signal. |
| 029 | Suspicious shortened link | `bit.ly/abc` | Risk amplifier. |
| 030 | Multiple short links | `tinyurl + t.co` | Strong spam signal. |
| 031 | Repeated punctuation urgency | `HEMEN!!!` | Risk amplifier only, not sufficient alone. |
| 032 | All caps bank OTP | `ONAY KODUNUZ 551122` | Preserve safe classification. |
| 033 | All caps bahis spam | `FREEBET HEMEN KAYIT` | Detect as spam. |
| 034 | Missing vowels in bahis | `bhs bonus` | Detect if combined with strong secondary clues. |
| 035 | Slang gambling | `kuponu patlat` | Risk signal, likely spam with other betting terms. |
| 036 | Slang personal chat | `kanka ara beni` | Allow normal. |
| 037 | Turkish suffix variation | `kargonuzu`, `kargonuzun` | Recognize transactional stems. |
| 038 | Turkish tense variation | `dagitima cikmistir` vs `dagitima cikti` | Match both. |
| 039 | Turkish formal typo | `randevu onaylanmistir` | Match safely. |
| 040 | Unicode fancy letters | `bahis` with styled Unicode | Normalize where feasible or mark suspicious. |
| 041 | Mixed safe + spam | `onay kodunuz 5512, bonus icin tiklayin` | Prefer review, investigate conflict. |
| 042 | Mixed cargo + fee | `teslimat icin 14 TL odeme` | Review or spam, not transactional allow. |
| 043 | Mixed bank + prize | `banka odulu kazandiniz` | Scam/spam, not bank-safe. |
| 044 | Mixed hospital + payment link | `provizyon reddedildi, kartinizi girin` | Review or spam. |
| 045 | Numeric-only sender token | sender unknown, text safe OTP | Content-based critical allow. |
| 046 | No spaces between keywords | `dogrulamakodu5512` | Recover with regex where possible. |
| 047 | Excess whitespace | `dogrulama    kodunuz   5512` | Collapse whitespace. |
| 048 | Tabs/newlines in SMS | multiline content | Normalize whitespace safely. |
| 049 | Trailing punctuation | `kodunuz: 5512...` | Preserve safe detection. |
| 050 | URL in legitimate cargo SMS | official carrier domain | Allow if safe domain and context align. |
| 051 | URL in legitimate bank SMS | official domain help page | Allow if no credential request. |
| 052 | Brand mention without sender proof | `Garanti uyari` plus weird URL | Still suspicious. |
| 053 | Turkish-English fake urgency | `account locked hemen click` | Review/spam. |
| 054 | Reward scam with symbols | `odul kazandiniz***` | Spam. |
| 055 | Government impersonation with payment request | `vergi iadeniz icin kart` | Spam. |
| 056 | Official reminder without link | `emlak vergisi son tarih` | Allow normal or transactional. |
| 057 | Education platform login code | `eBA giris kodu` | Critical allow. |
| 058 | School notice | `yarin veli toplantisi` | Allow normal. |
| 059 | Cargo pickup code | `subeden alim kodu` | Transactional allow. |
| 060 | Package on hold generic | `paketiniz bekliyor` | Review only if paired with suspicious CTA. |
| 061 | Seller marketplace transaction | `Param Guvende kargo kodu` | Transactional allow. |
| 062 | OTP with 4 digits | `4412` | Allow if surrounded by OTP words. |
| 063 | OTP with 6 digits | `441122` | Critical allow. |
| 064 | OTP with 8 digits | `22990011` | Critical allow if phrasing is strong. |
| 065 | Delivery code mistaken as OTP | `kurye kapida kod 4412` | Transactional allow. |
| 066 | Appointment reminder containing code | `randevu kodunuz 1234` | Transactional allow. |
| 067 | Telecom package ad vs service notice | `paketiniz yenilendi` | Transactional allow. |
| 068 | Telecom pure marketing | `super firsatli tarife` | Promotional filter if no account context. |
| 069 | Banking marketing | `ihtiyac kredisi firsati` | Promotional filter, not critical allow. |
| 070 | Bank login code plus loan ad footer | mixed content | Critical allow if OTP dominates and ad is footer-only. |
| 071 | Bahis with Turkish suffixes | `bahiscilere ozel` | Detect root. |
| 072 | Casino with Turkish characters omitted | `casino giris` | Spam. |
| 073 | Free spin variation | `freespin`, `free spin` | Detect both. |
| 074 | Bonus spacing | `deneme bon usu` | Catch if compacted text matches. |
| 075 | Reordered scam phrase | `tiklayin yoksa hesabiniz kapanacak` | Detect independent of word order. |
| 076 | Abbreviated cargo names | `YK`, `AK`, `PTT` | Use cautiously; do not overtrust abbreviations. |
| 077 | Abbreviated bank names | `GBBVA`, `YKredi` | Do not grant safe override on abbreviation alone. |
| 078 | Sender spoof risk | trusted brand in text but unknown sender | Require structure, not brand alone. |
| 079 | Referral marketing | `arkadasini getir kazan` | Promotional unless tied to gambling. |
| 080 | Survey incentive SMS | `ankete katil hediye cek kazan` | Promotional or suspicious based on link. |
| 081 | Adult-content spam | `gizli sohbet hatti` | Spam or promotional depending on severity. |
| 082 | Loan scam | `hemen kredi cikti` | Review/spam depending on phrasing. |
| 083 | Debt collection impersonation | `icra dosyasi acildi` | Review suspicious. |
| 084 | Tax scam | `vergi borcu icin hemen odeme` | Spam with odd link or card request. |
| 085 | Hospital scam using MHRS | `MHRS odeme linki` | Review/spam. |
| 086 | Government spacing typo | `turkiye gov tr` | Recognize official mention, but not enough alone. |
| 087 | Non-Turkish harmless text | `See you at 5` | Allow normal. |
| 088 | Non-Turkish phishing | `verify now to unlock` | Review suspicious. |
| 089 | Personal money request | `iban atar misin` | Allow normal absent scam indicators. |
| 090 | Personal shortened link | friend shares `bit.ly` | Do not auto-spam without other risk markers. |
| 091 | Long benign invoice | utility bill reminder | Transactional allow. |
| 092 | Long promotional retail SMS | seasonal sale with unsubscribe | Promotional filter. |
| 093 | Long phishing bank clone | urgent update plus fake domain | Spam. |
| 094 | Unknown sender but safe doctor reminder | appointment structure | Transactional allow. |
| 095 | Unknown sender but safe OTP | code structure and wording | Critical allow. |
| 096 | Unknown sender with vague urgency | `hemen ac` | Review suspicious only. |
| 097 | Numeric substitution in bank word | `b4nka` | Do not rely on token alone. |
| 098 | Diacritic-stripped official text | `randevunuz onaylandi` | Must still match safe set. |
| 099 | Mixed punctuation and spaces in spam | `b . a . h i s` | Compact and detect. |
| 100 | Empty or unparsable body | empty string | Default to allow normal fail-safe. |

## Testing Use

- Every edge case should eventually map to at least one automated regression test.
- Mixed-content cases are especially important because they create the highest false-positive risk.

## Trust-first example pairs

### Why bank messages must be strongly protected

Safe bank message:

- `Is Bankasi: Internet subesi giris denemeniz icin onay kodunuz 482911. Kimseyle paylasmayin.`
- Expected handling: `ALLOW_CRITICAL`
- Reason: very high `SAFE_SCORE`; critical protection layer applies

Scam bank-like message:

- `Is Bankasi hesabiniz kilitlendi. Giris icin isbank-guvenli.link adresine sifrenizi yazin.`
- Expected handling: `REVIEW_SUSPICIOUS`
- Reason: both safe-looking and risky signals exist; never directly filter in conflict

### Safe vs fake cargo

Safe cargo message:

- `MNG Kargo: 902134 takip no'lu paketiniz subeye ulasmistir.`
- Expected handling: `ALLOW_TRANSACTIONAL`
- Reason: operational logistics with stronger `SAFE_SCORE`

Fake cargo message:

- `PTT teslimati icin 14 TL odeme yapin, aksi halde paketiniz iade olacak: ptt-odeme.top`
- Expected handling: `REVIEW_SUSPICIOUS`
- Reason: cargo context conflicts with payment-trap risk

### OTP vs phishing

Safe OTP:

- `Dogrulama kodu 771204. Bu kodu kimseyle paylasmayin.`
- Expected handling: `ALLOW_CRITICAL`
- Reason: classic OTP structure and no risky behavior

Phishing-like OTP:

- `Dogrulama kodu 771204. Hesabinizi korumak icin linke tiklayip sifrenizi girin.`
- Expected handling: `REVIEW_SUSPICIOUS`
- Reason: safe-like OTP structure conflicts with credential theft prompt
