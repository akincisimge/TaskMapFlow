# Mimari kararlar

- Android ve Flutter; özellik bazlı presentation/domain/data ayrımı.
- Backend Firebase Auth + Firestore + Functions; ilk commit yalnız createProject komutunu uygular.
- Güvenilir komutlar: üyelik/rol, şema, idempotency, transaction ve activity. İstemci kontrolleri güvenlik değildir.
- Proje üyeliği yetki kaynağı; users/{uid}/projectRefs yalnız listeleme indeksidir.
- Görev durumları Todo/InProgress/Done; blocked bağımlılıklardan türetilir.
- Demo in-memory'dir. Gerçek backend yazımı veya ekip senkronizasyonu taklit edilmez.
- İleride DAG değişimleri proje graph revision belgesi üzerinden transaction ile koordine edilir.
- Kişisel reminder, proje sohbetinden ve görev teslim tarihinden ayrıdır.
- Kurumsal workspace, push, dosya ve özel iş akışı editörü sonraki sürümdür.

Ürün vizyonuyla eşleşme: mobil arayüz, görev haritası, alt görevler, bağımlılıklar ve gerçek zamanlı ekip görünürlüğü korunur. Sonuncusu bu iskelette henüz uygulanmamıştır. Öğrenci numaraları içeren orijinal ödev belgesi public repoya eklenmemiştir.
