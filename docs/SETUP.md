# Yerel kurulum ve Firebase bağlantısı

## 1 Demo uygulaması

README komutlarıyla Flutter bağımlılıklarını kurup Android'de çalıştırın. `lib/app/task_map_flow_app.dart` demo repository'lerini bağlar. Demo modunda kullanıcı hesabı, kalıcı kayıt, sohbet ve bildirim yoktur.

## 2 Firebase development projesi

Ekip sahibi kendi Google hesabında ayrı development Firebase projesini seçer/oluşturur. Authentication Email/Password sağlayıcısını ve Firestore'u kontrollü biçimde etkinleştirir. Bu repository bu işlemleri otomatik yapmaz.

Resmi yönerge: https://firebase.google.com/docs/flutter/setup

```sh
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
flutterfire configure --platforms=android
flutter pub add firebase_core firebase_auth cloud_firestore cloud_functions
```

SDK bağımlılıkları zaten varsa `pub add` zorunlu değildir. FlutterFire tarafından oluşturulan `lib/firebase_options.dart` ve Android yapılandırması yerelde kalır; her ekip üyesi onaylı development projesiyle kendi yapılandırmasını üretir.

## 3 Gerçek uygulamaya geçiş

Henüz tek bayrakla açılan bir Firebase modu yoktur. Önce Auth akışı ve oturum durumları uygulanmalıdır. Sonra `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` ile başlangıç eklenir ve ProjectRepository, `FirebaseProjectRepository` ile bağlanır. Functions örneği `FirebaseFunctions.instanceFor(region: 'europe-west1')` kullanmalıdır. İstemci kimliği sunucuda token'dan alınır; UI'dan gönderilen uid yetki sayılmaz.

`createProject` idempotent sunucu komutudur. Görev/bağımlılık yazımları henüz uygulanmadığı için Rules bu yazımları kapalı tutar. Firebase'e geçerken in-memory görev repository'siyle gerçek proje repository'sini birlikte kullanmayın.

## 4 Emulator ve dağıtım

`firebase.json` yerel Emulator portlarını ve Rules yollarını tanımlar. `firebase/.firebaserc` gerekmez; test komutu `demo-taskmapflow` kullanır. Functions birimi `functions` dizinindedir.

Dağıtımdan önce gerçek proje kimliğini açıkça seçin; Functions plan/faturalandırma koşullarını kontrol edin. Bu iskelet için deploy komutu otomatik çalıştırılmaz. CI yalnızca doğrulama yapar.

## 5 Android

Android applicationId başlangıçta `com.teamendura.taskmapflow` olur. Yayın veya Firebase kaydı öncesinde ekip bunu sabitlemelidir. Debug uygulaması geliştirme içindir; release imzası veya mağaza dağıtımı hazırlanmadı.
