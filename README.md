# DailyPlan

A minimalist iOS app for setting and tracking daily goals. Built with SwiftUI.

---

## Features

- **Daily Goals** — Add goals for today. Everything resets at midnight automatically, even if the app stays open.
- **Progress Tracking** — Live progress bar and percentage counter with smooth spring animations.
- **Per-User Goals** — Each account has its own isolated goal storage.
- **Local Auth** — Email and password authentication stored on-device. Session persists across app launches.
- **Delete Account** — Full account removal with confirmation dialog.
- **Liquid Glass UI** — Built for iOS 26 with native `glassEffect` and minimalist typography.

---

## Stack

- **SwiftUI** — 100% declarative UI
- **UserDefaults** — Local persistence for auth and goals
- **Combine** — Reactive state via `ObservableObject`
- **No third-party dependencies**

---

## Project Structure

```
DailyPlan/
├── DailyPlanApp.swift       # App entry point, injects AuthManager
├── RootView.swift           # Routes between ContentView and HomeView based on session
├── ContentView.swift        # Landing / onboarding screen
│
├── Auth/
│   ├── AuthManager.swift    # Login, register, logout, delete account
│   └── LoginView.swift      # Sign in / sign up with animated transitions
│
├── Home/
│   └── HomeView.swift       # TabView root (Goals + Settings)
│
├── Goals/
│   ├── GoalsView.swift      # Daily goals list with progress bar
│   ├── GoalsManager.swift   # CRUD + daily reset logic
│   └── AddGoalSheet.swift   # Bottom sheet for adding a new goal
│
└── Settings/
    └── SettingsView.swift   # Account info, sign out, delete account
```

---

## How Auth Works

User credentials are stored in `UserDefaults` as a dictionary:

```
"registeredUsers" → { "email": "password" }
"loggedInEmail"   → "email"  ← active session
```

> ⚠️ Passwords are stored in plaintext. This is fine for prototyping — use Keychain or a backend for production.

---

## How Daily Reset Works

Goals reset when the date changes. This is checked in three places:

1. **App launch** — `GoalsManager.init()` compares saved date vs today
2. **App returns from background** — `scenePhase` `.active` triggers `checkAndReset()`
3. **Every 60 seconds while app is open** — `Timer` fires `checkAndReset()` to catch midnight edge cases

---

## Requirements

| | |
|---|---|
| Platform | iOS 18+ |
| Liquid Glass (`glassEffect`) | iOS 26+ |
| Language | Swift 5.9+ |
| Xcode | 16+ |

---

## Getting Started

1. Clone the repo
2. Open `DailyPlan.xcodeproj` in Xcode
3. Select a simulator or device
4. Build and run (`⌘R`)

No configuration needed — everything runs locally on device.

---

## Roadmap

- [ ] Keychain-based password storage
- [ ] Streak tracking across days
- [ ] Push notifications for daily goal reminder
- [ ] iCloud sync
- [ ] Widget support

---

## Author

**Arco Zakwan Putra**
