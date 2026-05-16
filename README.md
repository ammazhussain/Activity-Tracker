# 🏃‍♂️ Activity Tracker

A lightweight Flutter app for tracking fitness activities like running, walking, swimming, and cycling. It uses local storage to persist user profiles, activities, and avatars.

---

## 📱 Features

- 🔐 Register/Login system (local storage)
- 🎯 Goal and BMI tracking
- 📝 Add/Edit/Delete Activities
- ✅ Mark activities as done
- 📊 Dashboard shows total distance
- 🗂 History of completed activities
- 👤 Profile page with avatar selection from gym-themed assets

---

## 🛠 Technologies Used

| Layer        | Technology                        |
|--------------|------------------------------------|
| Frontend     | Flutter, Dart                      |
| Storage      | SharedPreferences (local storage)  |
| State Mgmt   | Stateful Widgets with `setState()` |
| UI Design    | Material Design                    |
| Assets       | Custom PNG avatars/icons           |

---

## 🧭 App Structure

```
lib/
├── main.dart                    # Entry point
├── home_screen.dart             # Dashboard with distance counters
├── login_screen.dart            # Email/password login
├── register_screen.dart         # Signup form with goal selection
├── profile_screen.dart          # User profile, avatar, activities
├── choose_activity_page.dart    # Activity creation with time & reminder
├── history_screen.dart          # Displays completed activities
├── services/
│   └── local_storage_service.dart  # SharedPreferences logic
├── theme/
│   └── app_theme.dart           # Custom theming (if any)
└── assets/
    └── avatars/                 # Gym-style avatars
```

---

## 🔄 Data Flow

- User profile is stored as a JSON string in SharedPreferences (`user_profile`).
- Activities are saved as a list of JSON objects (`activities`).
- Completed activities are moved to `history_activities`.
- Avatars are selected from predefined images and stored as path (`user_avatar_path`).
- Totals (Running, Cycling, Swimming) are recalculated after each activity update.

---

## 📊 Visual Data Flow Chart

```mermaid
graph TD;
    A[Register] --> B[SharedPreferences: Save Profile];
    B --> C[Choose Activity];
    C --> D[Activity List];
    D --> E[Profile Screen];
    D --> F[Home Dashboard];
    D --> G[History Screen];
    E --> H[Mark as Done];
    H --> I[SharedPreferences: history_activities];
    I --> F
```

---
## 📸 App Screenshots

| Splash Screen | Login Screen |
|--------------|-----------------|
| <img width="373" alt="Splash Screen" src="https://github.com/user-attachments/assets/463efbb9-41e1-4594-a659-1804eb8e92d5" /> | <img width="374" alt="login" src="https://github.com/user-attachments/assets/51da7945-7640-4314-b7d8-43040de4bf60" /> |

| Register Screen | Home Screen |
|--------------|-----------------|
| <img width="373" alt="register" src="https://github.com/user-attachments/assets/f87db25a-4048-484d-968c-7f51133361d1" /> | <img width="374" alt="home" src="https://github.com/user-attachments/assets/f5a00573-bd07-4653-9441-2e2d134b12c7" /> |

| Choose Activity | Select Time |
|-----------------|-------------|
| <img width="376" alt="Choose Activity" src="https://github.com/user-attachments/assets/c64a8664-ef65-491e-b0e4-e8d32fb493ac" /> | <img width="373" alt="Time Selection Chose Activity" src="https://github.com/user-attachments/assets/b707708a-11e4-4196-8a3b-57bfb1397d26" /> |

| Profile Page | Activity History |
|--------------|------------------|
| <img width="374" alt="Activity list" src="https://github.com/user-attachments/assets/f55d1acf-1c8b-441e-9e6e-9bb89b2c40e8" /> | <img width="373" alt="History" src="https://github.com/user-attachments/assets/88b96735-1b42-4714-a943-67b96b185785" /> |

---

## 🚀 Getting Started

```bash
git clone https://github.com/yourusername/activity-tracker.git
cd activity-tracker
flutter pub get
flutter run
```

Make sure you add avatar images inside the `/assets/avatars` folder and declare them in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/runner.png
    - assets/dashboard.png
    - assets/avatars/dumbbell.png
    - assets/avatars/barbell.png
    - assets/avatars/yoga.png
    - assets/avatars/runner.png
    - assets/avatars/boxing.png
    - assets/avatars/trainer.png
```

---

## 📄 License

This project is licensed under the MIT License.
