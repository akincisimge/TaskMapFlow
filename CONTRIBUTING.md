# Katkı süreci

1. Backlog'dan tek bir iş seçin; owner ve farklı bir reviewer belirleyin.
2. `git switch main` ve `git pull --ff-only` ile güncelleyin.
3. `feature/...`, `fix/...` veya `chore/...` branch'i açın.
4. İlgili testleri çalıştırın; küçük bir PR açın. Main'e doğrudan commit göndermeyin.
5. Review ve CI geçtikten sonra birleştirin.

Domain SDK bağımsızdır. UI içinde Firestore sorgusu veya yetki kuralı yazmayın. Demo başarısını gerçek backend başarısı olarak göstermeyin. Service account, parola, gerçek kullanıcı verisi ve imzalama anahtarı eklemeyin.

Done: kabul ölçütü, hata/boş/yükleniyor durumları, ilgili test, yetki kontrolü ve kurulum notu tamamlanmıştır.
