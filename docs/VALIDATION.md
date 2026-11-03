# Başlangıç doğrulaması

3 Kasım 2026

- Flutter 3.47.9 / Dart 3.13.7 ile bağımlılıklar çözümlendi ve lockfile eklendi.
- Dart format kontrolü yapıldı.
- Flutter domain ve widget testleri: 4 başarılı.
- TypeScript derlemesi ve input doğrulama testleri: 2 başarılı.
- Firestore Emulator Rules senaryoları: 3 başarılı.
- Gerçek Emulator transaction entegrasyonu: eşzamanlı tekrar istek tek proje/üyelik/indeks/etkinlik üretiyor; aynı requestId farklı içerikle reddediliyor.

Bu ortamda Android SDK bulunmadığından yerel APK derlemesi yapılmadı. GitHub Actions Android debug APK derlemesini de çalıştırır. Gerçek Firebase projesine dağıtım, gerçek cihaz testi ve Auth entegrasyonu henüz yapılmadı. Sunucu DAG yarış kontrolü sonraki iş paketidir; mevcut DAG testleri yalnız demo/domain kurallarını doğrular.
