# Batch QR Code Tracking System
A full-stack application to track and monitor fertilizer batch movements via QR codes, with real-time scan logging (IP + geolocation), Code Blue alerts, and a Google Sheets-backed monitoring system.

## 🧩 Features
### 🔹 Batch QR Generator
Generates a unique QR code per batch containing:
- Batch ID
- Production Date
- Plant Location
- Product Type
- Vehicle Number
### 🔹 View Database
- Displays saved batches
Each entry shows:
 - Batch info
 - QR code
 - Download All as CSV option (platform-specific)
### 🔹 Code Blue
- Mark critical or sensitive batches as Code Blue
- Special QR codes for these trigger logging
### 🔹 Monitor (Scan Logger)
- Fetches real-time scan logs from backend
Displays:
 - IP Address
 - Location (City, Region, Country)
 - Timestamp
 - Batch ID
- Data comes from Google Sheets API via Apps Script endpoint
- Manual Refresh button and auto-refresh every 10s

## Tech Stack
### 🔹 Frontend (Flutter)
- Flutter Web + Android (cross-platform)
- CSV export (conditional)
- QR code generation
- IP/location-based logging links for Code Blue QR codes
### 🔹 Backend (FastAPI on Render)
/scan/<batchID> route:
 - Logs IP & geolocation via IPinfo.io
 - Writes to a connected Google Sheet using a published Apps Script webhook
/scanlogs route:
 - Fetches scan logs in JSON format for frontend
### 🔹 Logging Backend (Google Sheets)
Stores logs as:
 - Timestamp
 - Batch ID
 - IP Address
 - Location

## How It Works
### 1. Create QR Code:
Generate QR from user inputs → Encodes info into a URL.
### 2. Scan Happens:
External apps (like Google Lens) scan the QR → open backend URL (/scan/BATCHID).
### 3. Log Captured:
Backend extracts IP + geo-location → sends it to Google Sheet.
### 4. Frontend Monitor:
Displays latest entries.

## Security Notes
- No personal data is collected.
- IP & location are fetched only when Code Blue QR is scanned.
- All logs stored securely in your controlled Google Sheet.

## Deployment
### Backend (Render)
1. Deploy index.js render backend
2. Set environment variable: GOOGLE_SCRIPT_URL = (https://script.google.com/macros/s/AKfycbwTDDZBmwX-d3B-Ep56dxWOBbe0fTlBwSjuXEMw16xR85EKs9xD6CxrY6jtNbdGID4Fjw/exec?action=scanlogs)
### Flutter Frontend
1. Run on mobile (NFL application)
2. Or build for web (flutter build web)
3. Host via Render, GitHub Pages, or a local server

## Folder Structure (Frontend)
lib/

├── main.dart

├── qr_generator.dart

├── batch_database.dart

├── code_blue.dart

├── monitor.dart

## Future Enhancements
- Admin dashboard for managing Code Blue status
- Authenticated scan logging
- Export scan logs to CSV
