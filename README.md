# 🤖 Sentiric Assistant (Mobile Client)

[![Language](https://img.shields.io/badge/language-Flutter_/_Dart-blue.svg)]()
[![Platform](https://img.shields.io/badge/platform-iOS_/_Android-green.svg)]()

Bu proje, **Sentiric Platformu** için geliştirilmiş, Flutter tabanlı bir mobil sesli asistan istemcisidir.

## 🎯 Amaç

Bu uygulamanın temel amacı, `sentiric-stream-gateway-service` ile gerçek zamanlı, çift yönlü (full-duplex) sesli iletişimin nasıl kurulacağını gösteren bir referans implementasyon olmaktır.

## 🛠️ Teknoloji Yığını

-   **Framework:** Flutter
-   **Dil:** Dart
-   **Ağ İletişimi:** WebSocket (`web_socket_channel`)
-   **Ses Girişi:** `mic_stream` (16kHz PCM @ 16-bit Mono formatında)
-   **Ses Çıkışı:** `audioplayers` (Düşük gecikmeli streaming için)
-   **Konfigürasyon:** `flutter_dotenv`

## 🚀 Kurulum ve Çalıştırma

### 1. Konfigürasyon
Projenin kök dizininde `.env` adında bir dosya oluşturun ve içine bağlanmak istediğiniz `stream-gateway` adresini yazın:

```
STREAM_GATEWAY_URL="wss://your-gateway-address.com/ws"
```
*Geliştirme için Android emülatöründen localhost'a erişmek için `ws://10.0.2.2:18030/ws` kullanabilirsiniz.*

### 2. Bağımlılıkları Yükle
```bash
flutter pub get
```

### 3. Uygulamayı Çalıştır
```bash
flutter run
```

---

## 🔒 Güvenlik Notları
-   **WSS:** Üretim ortamında `wss://` (Güvenli WebSocket) kullanılması zorunludur. `stream-gateway` servisiniz bir ters proxy (örn: Nginx, Caddy) arkasında olmalı ve geçerli bir SSL sertifikasına sahip olmalıdır.
-   **Mikrofon İzni:** Uygulama, ilk açılışta mikrofon izni isteyecektir. Bu izin, `permission_handler` paketi ile yönetilir.
