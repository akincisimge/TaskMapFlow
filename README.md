# TaskMapFlow

SE 2001 · Group 4 · Team Endura

Flutter ve Firebase ile Android için geliştirilen görsel görev ve iş akışı yönetim uygulaması. Ürün vizyonu: sade mobil kullanım, alt görevler, açık görev bağımlılıkları ve gerçek zamanlı ekip görünürlüğü.

## Mevcut durum

Bu repository başlangıç iskeletidir. **Varsayılan uygulama yerel demo verileriyle çalışır; oturum açmaz ve Firebase'e bağlanmaz.** Uygulama kapanınca demo değişiklikleri silinir. Proje özeti, görev ekleme/durum değiştirme ve bağımlılık haritası örneği vardır. Gerçek zamanlı ekip senkronizasyonu henüz uygulanmamıştır.

Firebase tarafında tipli repository adaptörü, güvenilir proje oluşturma komutu, varsayılan kapalı erişim kuralları ve test altyapısı hazırlanmıştır. Firebase projesi oluşturulmamış, ücretli servis açılmamış ve dağıtım yapılmamıştır.

## Hızlı başlangıç

Flutter sürümü `.flutter-version` dosyasındadır. Android Studio/Android SDK, JDK ve bir Android cihaz veya emülatör gerekir.

```sh
git clone https://github.com/akincisimge/TaskMapFlow.git
cd TaskMapFlow
flutter doctor
flutter pub get
flutter run
```

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
cd functions
npm ci
npm test
npm run build
```

Firebase Emulator güvenlik testleri için kökten:

```sh
npm --prefix functions ci
cd firebase
npm ci
npm test
```

Emulator testi Node.js, Java 21+ ve internetten ilk emulator indirmesini gerektirir. Gerçek Firebase projesi veya faturalandırma gerektirmez.

## Mimari

- `lib/app`: uygulama kökü, tema ve bağımlılıkların bağlanması.
- `lib/core`: paylaşılan hata tipleri.
- `lib/features/projects`: proje entity ve repository, demo/Firebase adaptörleri, proje ekranı.
- `lib/features/tasks`: görev modeli, iş kuralları, demo adaptörü ve pano.
- `lib/features/dependencies`: DAG denetimi ve görsel harita.
- `auth`, `membership`, `activity`, `chat`, `reminders`: sonraki modüllerin sorumluluk belgeleri.
- `functions`: TypeScript komut katmanı; başlangıçta yalnızca `createProject` uygulanmıştır.
- `firebase`: Rules, indeksler ve Emulator testleri.
- `docs`: kurulum, geliştirme sırası ve mimari kararlar.

Domain katmanı Flutter/Firebase import etmez. Ekranlar Firestore çağırmaz. Hassas yazımlar sunucu komutlarına aittir.

## Belgeler

- [Mimari tasarım raporu](docs/architecture/TaskMapFlow_Mimari_Tasarim.pdf)
- [Kurulum ve Firebase bağlantısı](docs/SETUP.md)
- [Geliştirme planı](docs/BACKLOG.md)
- [Mimari kararlar](docs/architecture/DECISIONS.md)
- [Katkı süreci](CONTRIBUTING.md)

## Teslim kapsamı

MVP: kimlik, proje/üyelik, görev ve alt görev, DAG, pano/harita, canlı ilerleme, temel etkinlik geçmişi. MVP+: proje başına tek metin sohbeti ve kişisel yerel hatırlatmalar. Ücretsiz kullanıcı deneyimi hedeflenir; altyapı maliyetleri ayrıca izlenmelidir.
