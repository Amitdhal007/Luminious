<p align="center">
  <h1 align="center">🚗 Luminious</h1>
  <p align="center">
    <strong>Real-Time Vehicle Fleet Telemetry & Simulation Platform for iOS</strong>
  </p>
  <p align="center">
    <img src="https://img.shields.io/badge/Platform-iOS%2026.1+-000000?style=flat-square&logo=apple&logoColor=white" />
    <img src="https://img.shields.io/badge/Xcode-26.2+-147EFB?style=flat-square&logo=xcode&logoColor=white" />
    <img src="https://img.shields.io/badge/Swift-6.0-FA7343?style=flat-square&logo=swift&logoColor=white" />
    <img src="https://img.shields.io/badge/Architecture-MVVM--C-0D9488?style=flat-square" />
    <img src="https://img.shields.io/badge/Status-90%25%20Complete-22C55E?style=flat-square" />
  </p>
</p>

---

## 📋 Table of Contents

- [About the Project](#-about-the-project)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Application Flow](#-application-flow)
- [Implemented Features](#-implemented-features)
- [Pending Work — AR Feature](#-pending-work--ar-feature)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Repository Access](#-repository-access)
- [Deliverables & Attachments](#-deliverables--attachments)
- [Author](#-author)

---

## 🎯 About the Project

**Luminious** is a native iOS application that delivers a real-time vehicle fleet monitoring, intelligent search, and telemetry simulation experience. It is engineered from the ground up using **Clean Architecture** principles combined with the **MVVM-Coordinator (MVVM-C)** design pattern — ensuring strict separation of concerns, testability, and long-term maintainability.

All data — including sessions, vehicles, routes, and coordinate telemetry — is persisted locally using **CoreData** (SQLite-backed). The interface showcases a premium, modern design language with Apple's native **Liquid Glass** (`UIGlassEffect`) components, delivering a polished, production-grade user experience.

> **⚠️ Important:** This application requires **iOS 26.1+** and **Xcode 26.2+** to compile and run, due to dependencies on native `UIGlassEffect` APIs and latest UIKit rendering features.

---

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| **Language** | Swift 6.0 (Strict Concurrency) |
| **UI Framework** | UIKit — Storyboards + Programmatic Layouts |
| **Design System** | Native iOS 26 Liquid Glass (`UIGlassEffect`) |
| **Reactive Bindings** | Combine (Publishers, Subjects, Subscribers) |
| **Local Database** | CoreData with SQLite persistent store |
| **Location Engine** | CoreLocation + CLGeocoder (Reverse Geocoding) |
| **Mapping & Routing** | MapKit — `MKMapView`, `MKDirections`, `MKPolyline` |
| **Image Loading** | SDWebImage v5.21.7 (via Swift Package Manager) |
| **Minimum Deployment** | iOS 26.1+ |
| **Build Toolchain** | Xcode 26.2+ |
| **Architecture** | Clean Architecture + MVVM-Coordinator (MVVM-C) |
| **Dependency Manager** | Swift Package Manager (SPM) |

---

## 🏛 System Architecture

The codebase is structured into three decoupled layers following the **Dependency Inversion Principle** — inner layers define contracts, outer layers implement them.

```
┌──────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│                                                              │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │
│   │    Views      │◄──►│  ViewModels  │◄──►│ Coordinators │   │
│   │  (UIKit VCs)  │    │  (Combine)   │    │  (Routing)   │   │
│   └──────────────┘    └──────────────┘    └──────────────┘   │
│                                                              │
│   Factories: Instantiation & DI Resolution                   │
└──────────────────────────┬───────────────────────────────────┘
                           │  Protocols / Contracts
┌──────────────────────────▼───────────────────────────────────┐
│                      DOMAIN LAYER                            │
│                                                              │
│   Entities:  Vehicle │ Session │ Route │ PlaybackState        │
│   Protocols: VehicleRepository │ SessionRepository │ RouteRepo│
│                                                              │
│   ⚡ Zero external dependencies — pure Swift business logic  │
└──────────────────────────▲───────────────────────────────────┘
                           │  Implements Contracts
┌──────────────────────────┴───────────────────────────────────┐
│                   INFRASTRUCTURE LAYER                        │
│                                                              │
│   CoreData Stack │ Location Services │ Geocoding Services     │
│   Telemetry Simulation │ Toast Engine │ Entity Mappers        │
└──────────────────────────────────────────────────────────────┘
```

### Key Design Patterns

| Pattern | Purpose |
|---|---|
| **Coordinator** | Decouples navigation from ViewControllers. Each flow (Splash, Map) owns a coordinator. |
| **Dependency Injection** | `AppContainer` assembles all dependencies; injected via Factories. |
| **Repository** | Domain defines data contracts; Infrastructure provides CoreData implementations. |
| **Pub-Sub (AppEventBus)** | Combine-powered event bus for loosely-coupled cross-module communication. |
| **Mapper** | Translates CoreData `NSManagedObject` entities to/from pure domain structs. |

---

## 📊 Application Flow

The complete lifecycle from app launch to session completion is illustrated below:

![Overall Application Flow Diagram](app_flow.png)

**Flow Summary:**
1. **App Launch** → `SceneDelegate` initializes `AppCoordinator` with assembled `AppContainer`
2. **Splash Screen** → Plays looping intro video, queries CoreData for cached sessions
3. **Session Decision** → Resume existing session or create new one (vehicle count picker)
4. **Route Bootstrap** → Generates random coordinates near user, fetches real driving routes via `MKDirections`
5. **Live Map Dashboard** → Displays vehicle annotations with real-time coordinate updates
6. **Telemetry Simulation** → Background timer advances vehicles along polylines every 5 seconds
7. **Vehicle Inspection** → Tap annotations to view driver details and trigger route playback
8. **Session Completion** → All vehicles reach destinations → redirects back to Splash

---

## ✅ Implemented Features

| # | Feature | Description |
|---|---|---|
| 1 | **Splash Screen with Video** | Looping MP4 intro animation with session-aware button states (Resume / New) |
| 2 | **Session Persistence & Recovery** | CoreData caches active sessions; cold starts prompt instant resume |
| 3 | **Intelligent Route Bootstrapping** | Generates routes using Apple Maps `MKDirections` around user's real GPS location |
| 4 | **Real-Time Telemetry Simulator** | 5-second background timer advances vehicles along cached polylines in CoreData |
| 5 | **Interactive Live Map** | Custom `MKAnnotationView` markers with smooth heading-based rotation animation |
| 6 | **Glass Search Drawer** | Combine-powered instant text filtering in a `UIGlassEffect` bottom sheet |
| 7 | **Trip Route Playback** | Frame-by-frame interpolation (25ms steps) animating a marker along historical paths |
| 8 | **Liquid Glass Design System** | `LiquidGlassButton`, `LiquidGlassSearchBar`, `DarkGlassButton` — all native `UIGlassEffect` |
| 9 | **Apple-Style Toast System** | Queued alerts (Success/Error/Warning/Info) with spring animations & swipe-to-dismiss |
| 10 | **Reverse Geocoding** | Translates GPS coordinates to readable street addresses via `CLGeocoder` |

---

## ⏳ Pending Work — AR Feature

> **Status: Stubbed — Not Implemented**

The AR button (using the `arkit` SF Symbol) is visible on the map interface and correctly wired through the Combine tap publisher pipeline:

```
MapVC → arButton.tapPublisher → coordinator?.mapDidRequestAR()
```

However, in [MapCoordinator.swift](Luminious/Features/Map/Navigation/Coordinator/MapCoordinator.swift), the handler body is empty:

```swift
func mapDidRequestAR() {
    // Stubbed — pending ARKit/RealityKit integration
}
```

**Why it's pending:** Due to the project timeline constraints, the AR feature could not be completed. All other features (90% of the application) are fully functional.

**Resolution Path:**
1. Create `Features/VehicleAR/` module with an `ARViewController`
2. Integrate `ARSCNView` (ARKit) or `ARView` (RealityKit)
3. Anchor 3D vehicle pins using `LocationAnchor` APIs
4. Wire `MapCoordinator.mapDidRequestAR()` to present the AR controller

---

## 🚀 Getting Started

### Prerequisites

| Requirement | Version |
|---|---|
| macOS | Sequoia 15.0+ |
| Xcode | **26.2+** (mandatory) |
| iOS Deployment Target | **26.1+** (mandatory) |
| Swift | 6.0+ |

### Installation & Run

```bash
# 1. Clone the repository
git clone <repository-url>
cd Luminious

# 2. Open in Xcode
open Luminious.xcodeproj

# 3. Wait for SPM to resolve dependencies (SDWebImage)

# 4. Select simulator: iPhone 16 Pro (iOS 26.0+)

# 5. Build & Run: ⌘ + R
```

> **💡 Simulator Tip:** Enable a simulated location under **Features → Location → Apple** or set a custom coordinate to ensure the geocoder and route generator function correctly.

---

## 📁 Project Structure

```
Luminious/
├── App/
│   ├── Container/          # AppContainer — DI assembly
│   ├── Coordinator/        # AppCoordinator — root flow control
│   └── System/             # AppDelegate, SceneDelegate
│
├── Domain/
│   ├── Models/             # Vehicle, Session, Route, PlaybackState
│   └── Repositories/       # Protocol contracts (zero dependencies)
│
├── Infrastructure/
│   ├── Persistence/        # CoreData stack, mappers, repository impls
│   ├── Mocks/              # Driver generation, route simulation, bootstrap
│   ├── Services/           # LocationManager, ToastManager
│   └── Loader/             # Loading indicator presenter
│
├── Features/
│   ├── Splash/             # Launch screen, video player, session check
│   ├── Map/                # Live tracking map, search, annotations
│   └── VehicleDetails/     # Driver card, route playback, trip status
│
├── Core/
│   ├── DesignSystem/       # LiquidGlassButton, SearchBar, VideoView
│   ├── Eventing/           # AppEventBus, AppEvent protocols
│   └── Navigation/         # Storyboard utilities
│
├── Common/                 # Extensions (Foundation, UIKit, Location, Polyline)
├── Resources/              # Assets, LaunchScreen storyboard
└── Views/                  # Storyboard references
```

---

## 🔗 Repository Access

```
📦 GitHub: https://github.com/<your-username>/luminious-ios
```

> Replace the placeholder URL above with the actual repository link before sharing.

---

## 📎 Deliverables & Attachments

All project deliverables are attached in the accompanying email:

| # | Attachment | Description |
|---|---|---|
| 1 | `Luminious_Architecture.docx` | Complete HLD & LLD document with ER diagrams, system flow, and class-level specifications |
| 2 | **Code Explanation Video** | Screen-recorded walkthrough of the codebase, architecture decisions, and feature demos |
| 3 | **Design Rationale** | Document explaining why Clean MVVM-C was chosen, thread safety strategies, and animation math |

---

## 👨‍💻 Author

**Amit Kumar Dhal**

---

<p align="center">
  <sub>Built with ❤️ using Swift, UIKit, Combine, CoreData & MapKit</sub>
</p>
