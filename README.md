# 🌦 Weather App (Flutter + Node.js)

Ứng dụng thời tiết gồm **Frontend (Flutter)** và **Backend (Node.js/Express)**.  
Người dùng có thể xem thông tin thời tiết trực tuyến thông qua API RESTful.

---

## 🧰 Công nghệ sử dụng

### 🔹 Frontend (Mobile)
- Flutter v3.29.2
- Dart 3.x
- `http` package (gọi REST API)

### 🔹 Backend (Server)
- Node.js v18+
- Express.js
- RESTful API

---

## 📂 Cấu trúc thư mục

```bash
weather_app/
│── fe_news_app/      # Flutter mobile app
│── be_news_app/       # Node.js Express server
└── README.md      # Tài liệu dự án
```

## 🚀 Hướng dẫn chạy dự án

### 1. Tải dự án

```bash
https://github.com/LaHuy136/news_app.git
```

### 2. Cài đặt backend

```bash
cd be_news_app
npm install
npm start
```

Server sẽ chạy tại:

```dart
http://<YOUR_LOCAL_IP>:3000
```

#### ⚠️ Lưu ý:

##### Nếu chạy trên thiết bị thật, không dùng localhost.

##### Hãy dùng IP LAN, ví dụ: http://192.168.1.10:3000

### 3. Cài đặt frontend

```bash
cd fe_news_app
flutter pub get
```

##### Cập nhật file cấu hình API URL trong Flutter:
```dart
const String baseUrl = "http://<YOUR_LOCAL_IP>:3000";
```
##### Chạy ứng dụng:

```bash
flutter run
```
