# 🏆 SportsZone

An iOS application that allows users to explore sports leagues, upcoming events, latest results, and team details — with offline favorites support.

---

## ✨ Features

- 🏠 **Home Screen** — Choose from 4 sports: Football, Basketball, Cricket, and Tennis
- 🏆 **Leagues Screen** — Browse all leagues for the selected sport
  - ⭐ Add/Remove leagues to favorites (Core Data)
  - 🔍 Search leagues by name
- 📋 **League Details** — View upcoming events, teams, and latest events for any league
- 👥 **Team Details** — Explore team info and player details

---

## 🏗️ Architecture

Built with **MVP (Model-View-Presenter)** and **Clean Architecture** principles:

```
SportsZone/
├── App/
├── Features/
│   ├── Home/
│   ├── Leagues/
│   ├── LeagueDetails/
│   └── TeamDetails/
├── Network/
│   ├── NetworkManager
│   └── RequestInterceptor
├── CoreData/
│   └── FavoritesManager
└── Utils/
```

---

## 🛠️ Tech Stack

| Category | Details |
|---|---|
| Language | Swift |
| UI | UIKit + Storyboard |
| Architecture | MVP + Clean Architecture |
| Networking | Alamofire |
| Image Loading | SDWebImage |
| Loading States | SkeletonView |
| Connectivity | Reachability |
| Persistence | Core Data |
| Dependency Manager | SPM |

---

## 🚀 Getting Started

### Prerequisites

- Xcode 14+
- iOS 14+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/mohsharafeldin/SportsZone.git
   cd SportsZone
   ```

2. Install dependencies:
   ```bash
   pod install
   ```

3. Open the workspace:
   ```bash
   open SportsZone.xcworkspace
   ```

4. Add your API key — the app reads it from the iOS Keychain. You can set it once on first launch or via the configuration file.

5. Build and run on a simulator or device ✅

---

## 🗂️ Supported Sports

| Sport | Leagues | Events | Teams |
|---|---|---|---|
| ⚽ Football | ✅ | ✅ | ✅ |
| 🏀 Basketball | ✅ | ✅ | ✅ |
| 🏏 Cricket | ✅ | ✅ | ✅ |
| 🎾 Tennis | ✅ | ✅ | ✅ |

---

## 👩‍💻 Developer

**Nadin Ahmed**
iOS Developer

**Mohammed Abdelsalam**
iOS Developer
