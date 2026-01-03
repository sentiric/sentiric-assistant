# 🗺️ Sentiric Assistant (Flutter) - Görev ve Yol Haritası

Bu belge, mobil asistan uygulamasının geliştirme görevlerini, önceliklerini ve gelecek vizyonunu tanımlar.

## ✅ Faz 1: Temel İşlevsellik (MVP) - Tamamlandı

Bu faz, uygulamanın temel ses giriş/çıkış yeteneklerini ve backend entegrasyonunu içerir.

- [x] **Altyapı:** Flutter projesi oluşturuldu, temel klasör yapısı kuruldu.
- [x] **Konfigürasyon:** `flutter_dotenv` ile dinamik WebSocket URL yönetimi eklendi.
- [x] **Güvenlik:** Mikrofon izni (`permission_handler`) yönetimi eklendi.
- [x] **Ses Girişi (`mic_stream`):**
    - [x] Mikrofon sesini yakalama.
    - [x] Sesi 16kHz, 16-bit Mono PCM formatına anlık dönüştürme (Client-Side Resampling).
- [x] **Ağ Katmanı (`web_socket_channel`):**
    - [x] `stream-gateway` servisine WebSocket bağlantısı kurma.
    - [x] Ses verisini binary frame olarak gönderme.
    - [x] Gelen ses ve metin mesajlarını dinleme.
- [x] **Ses Çıkışı (`audioplayers`):**
    - [x] Gelen ses paketlerini sıralı oynatmak için Jitter Buffer implementasyonu.
- [x] **UI:** Temel "Dokun ve Konuş" arayüzü oluşturuldu.

---

## 🚀 Faz 2: Gelişmiş Kullanıcı Deneyimi ve Arayüz (Sıradaki Görevler)

Bu faz, uygulamayı daha interaktif ve kullanıcı dostu hale getirmeye odaklanır.

- [ ] **UI: Konuşma Balonları (Chat Bubbles):**
    - [ ] Kullanıcının söylediği (STT'den dönen final metin) ve AI'ın yanıtladığı metinleri bir sohbet ekranında göster.
    - [ ] `stream-gateway`'den gelen `"type": "subtitle"` JSON mesajlarını dinle ve AI'ın baloncuğunu anlık olarak güncelle (Karaoke efekti).

- [ ] **UI: Durum Göstergeleri ve Animasyonlar:**
    - [ ] "Dinleniyor", "İşleniyor", "Konuşuyor" durumları için `GOREV_EMRI.md`'de belirtilen animasyonları ve görsel ipuçlarını ekle.
    - [ ] Ses dalgalarını görselleştiren bir animasyon (analyser node) ekle.

- [ ] **Ses: Otomatik Ses Aktivite Tespiti (VAD):**
    - [ ] Kullanıcı konuşmayı bıraktığında kaydı otomatik olarak durduran bir zamanlayıcı ekle. `mic_stream`'den gelen sesin RMS değerini analiz ederek sessizliği algıla.

- [ ] **Hata Yönetimi:**
    - [ ] WebSocket bağlantısı koptuğunda UI üzerinde net bir "Yeniden Bağlanılıyor..." mesajı göster.

---

## 🔮 Faz 3: Gelecek Vizyonu (Backlog)

Bu özellikler, platformun diğer yetenekleri geliştikçe eklenecektir.

- [ ] **Çok Modlu Giriş:** Metin yazma alanı ekle. Kullanıcı hem konuşabilir hem yazabilir.
- [ ] **Görsel Artefaktlar:** `stream-gateway`'den gelen ve HTML/Markdown içeren mesajları UI'da render et (örn: ürün kartları, grafikler).
- [ ] **Oturum Yönetimi:** Uygulama açıldığında önceki konuşmaları `dialog-service`'ten çekip ekrana getirme.
- [ ] **Ayarlar Ekranı:** Kullanıcının `stream-gateway` URL'sini, ses modelini (voice_id) veya dilini değiştirebileceği bir ayarlar sayfası ekle.