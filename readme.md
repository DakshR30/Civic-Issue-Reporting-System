GarudX - One Tap Samadhaan
<!-- Make sure you have your logo in the public folder of your web app -->

A real-time, cross-platform civic issue reporting and resolution system. This project features a Flutter app for citizens, a Next.js dashboard for administrators, and a complete Firebase backend for a seamless, end-to-end experience.

✨ Features
Citizen App (Flutter):

Multi-Language Support (English, Hindi, Marathi)

Secure Phone OTP Authentication via Firebase

One-Tap Issue Reporting with Image Capture

Automatic Geotagging of Issues with a Live Map View

Real-Time List of Recent Reports with Status Updates

Community Upvoting on Issues

User Profile Creation and Management

Admin Dashboard (Next.js):

Secure Admin Login

Live Map with Custom, Department-Specific Markers

Real-Time Table of All Incoming Reports with Filtering

Dynamic Chart for Visualizing Issue Trends

Ability to Update Report Status with a Click

Detailed View for Each Report with Image and Location

Backend (Firebase):

Firestore: Real-time NoSQL database for syncing reports and users.

Firebase Authentication: Handles secure OTP sign-in.

Firebase Storage: Stores all user-uploaded images.

Cloud Functions: Triggers automatic push notifications on report creation and resolution.

🛠️ Tech Stack
Mobile App: Flutter & Dart

Web Dashboard: Next.js, React, TypeScript, Tailwind CSS

Backend: Firebase (Auth, Firestore, Storage, Cloud Functions)

Mapping: Google Maps (Flutter), Leaflet (Web)

⚙️ Setup and Installation
Important: This project uses Firebase. You will need to create your own Firebase project and obtain your own google-services.json (for Android) and web config object.

1. Backend (Firebase Cloud Functions)
# Navigate to the functions directory
cd garudx-functions/functions

# Install dependencies
npm install

# Deploy the functions
firebase deploy --only functions

2. Web Admin Dashboard (Next.js)
# Navigate to the admin directory
cd garudx_admin

# Install dependencies
npm install

# Run the development server
npm run dev

3. Citizen App (Flutter)
Place your google-services.json file in one_tap_samadhaan/android/app/.

Add your Google Maps API key to one_tap_samadhaan/android/app/src/main/AndroidManifest.xml.

Run the app:

# Get dependencies
flutter pub get

# Run the app
flutter run
