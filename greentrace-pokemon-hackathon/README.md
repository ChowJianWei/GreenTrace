# GreenTrace Pokemon Hackathon

## Project Structure
```
greentrace-pokemon-hackathon/
├── frontend/
│   ├── flutter_mobile/
│   └── react_web/
├── backend/
└── .gitignore
```

## Step-by-step Run Guide (Beginner Friendly)

### 1) Backend API
1. `cd greentrace-pokemon-hackathon/backend`
2. `npm install`
3. `npm run start`

### 2) React Web
1. `cd greentrace-pokemon-hackathon/frontend/react_web`
2. `npm install`
3. `npm start`

### 3) Flutter Mobile
1. `cd greentrace-pokemon-hackathon/frontend/flutter_mobile`
2. `flutter pub get`
3. `flutter run`

## VSCode Flutter Mobile UI Preview Guide
1. Open VSCode and install the **Flutter** and **Dart** extensions.
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS).
3. Run **Flutter: Launch Emulator** and select a device (or connect a phone via USB).
4. Open `lib/main.dart` and press `F5` to start the app.
5. The phone preview will appear in the emulator or your connected device.

## Environment Variables
The app expects the following environment variables in your `.env` / `.env.local` files:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `NEXT_PUBLIC_SUPABASE_SERVICE_KEY`
- `NEXT_PUBLIC_MAPBOX_TOKEN`
- `API_BASE_URL`

