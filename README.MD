# IPCDeviceUtility

An iOS-based diagnostics and firmware management utility for IPC sled devices. Originally designed for enterprise deployment, this app provides field support for hardware diagnostics, secure login, and over-the-air firmware update management via SFTP.

---

## 📦 Features

### 🔐 LDAP Login & Role-Based Access
- Secure SOAP-based login system
- Admin/supervisor access via job code matching
- Unit number-based overrides
- User info stored locally with authentication timestamp

### 🧪 Diagnostic Testing
- 2D barcode scanner testing
- Magnetic Stripe Reader (MSR) read/write validation
- Visual pass/fail indicators for all tests

### 🔄 Firmware Flashing
- iOS version detection to control update compatibility
- IPC sled communication logic
- Initiates sled firmware flashing from within the app

### 📥 SFTP Firmware Update
- Authenticated SFTP support to retrieve firmware bundles
- Dynamic URL loading based on QA or Production environment
- Offline-first design with fallback and logging

### 📱 User Experience
- UI feedback with activity spinners
- Custom navigation & detail views for user/device info
- Modern Objective-C project structure with legacy support logic

---

## 🛠 Requirements

- Xcode 10+
- iOS 10+
- CocoaPods (if using Firebase analytics or support SDKs)

---

## ⚙️ Configuration

All environment settings and endpoint URLs are managed in:
```bash
AppConfig.plist
```

This allows you to:
- Toggle QA/Prod LDAP URLs
- Override SFTP hostnames
- Secure credential handling

---

## 🧾 License

MIT (or internal use only, based on deployment)

---

_Built with Objective-C, legacy-compatible design, and a passion for clean diagnostics._
