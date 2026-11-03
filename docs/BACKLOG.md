# Geliştirme sırası

| Sıra | İş | Kabul ölçütü |
| --- | --- | --- |
| 0 | Flutter iskeleti ve demo | Analiz, widget ve domain testleri geçer |
| 1 | Auth ve profil | Kayıt, giriş, sıfırlama, çıkış ve hata durumları |
| 2 | Proje oluşturma entegrasyonu | İki kullanıcının verisi ayrılır; tekrar istek tek proje üretir |
| 3 | Davet ve üyelik | Tek kullanımlık, süreli kod; çıkarılan üye erişemez |
| 4 | Sunucu görev komutları | Atama/alt görev/sürüm ve activity atomik; geçersiz atama reddedilir |
| 5 | Sunucu DAG ve geçiş kuralları | Eşzamanlı ters kenarlardan en fazla biri kabul edilir |
| 6 | Gerçek pano ve harita | İki cihazda yenilemesiz güncelleme; okunaklı harita |
| 7 | Sohbet | Üye erişimi, sayfalama ve tekrar gönderim denetimi |
| 8 | Yerel hatırlatma | İzin, saat dilimi, iptal ve çıkış gerçek cihazda test edilir |
| 9 | Teslim | Temiz kurulum, yetkisiz erişim ve uçtan uca demo |

Demo DAG denetimi sunucu güvenliği yerine geçmez. Görev komutları tamamlanmadan gerçek proje verisine demo görevleri bağlanmaz. Görsel harita ürün vizyonunun çekirdeğidir ve MVP'den çıkarılmaz.
