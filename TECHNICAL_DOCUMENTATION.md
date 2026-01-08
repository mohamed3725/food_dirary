# Technical Documentation - Food Diary App

## 1. Project Overview
**Food Diary** is a cross-platform mobile application built with Flutter that enables users to track their daily nutritional intake. It allows users to log meals with details like calories, protein, carbs, and fats, and securely stores this data in the cloud using Firebase.

## 2. System Architecture

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern, enhanced with a **Repository Pattern** for data abstraction.

### Layer Breakdown:
- **Presentation Layer (UI)**: 
  - Uses Flutter Widgets (Material 3).
  - Screens: `LoginScreen`, `RegisterScreen`, `HomeScreen`, `AddMealScreen`, `MealDetailScreen`.
  - Responsible for displaying data and capturing user interactions.

- **Business Logic Layer (ViewModels/Providers)**:
  - Managed using the `provider` package.
  - `MealProvider`: Manages the state of meal lists, filtering, and CRUD operations.
  - `AuthProvider`: Manages user authentication state (logged in/out).
  - `ConnectivityProvider`: Monitors network status for offline handling.

- **Data Layer (Repositories & Services)**:
  - `MealRepository`: Abstracts Firestore interactions.
  - `AuthService`: Handles Firebase Authentication methods.
  - `StorageService`: Manages image uploads to Firebase Storage.

## 3. Technology Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (BaaS)
  - **Authentication**: Firebase Auth (Email/Password)
  - **Database**: Cloud Firestore (NoSQL)
  - **Storage**: Firebase Storage (Images)
- **State Management**: Provider
- **Local Storage**: `shared_preferences` (Settings/Theme), `path_provider` (Local Image Caching)

## 4. Key Packages & Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | User authentication |
| `cloud_firestore` | Database operations |
| `provider` | State management |
| `image_picker` | Selecting images from gallery/camera |
| `cached_network_image` | Efficient image loading & caching |
| `share_plus` | Sharing meal details |
| `connectivity_plus` | Monitoring internet connection |
| `path_provider` | Accessing device file system |

## 5. Data Model

### Meal Class
The core data entity representing a food item.

| Field | Type | Description |
|-------|------|-------------|
| `name` | String | Name of the meal |
| `description` | String? | Optional details about the meal |
| `image` | String? | URL to the meal image |
| `calories` | int | Energy content |
| `protein` | double | Protein amount (g) |
| `carbs` | double | Carbohydrate amount (g) |
| `fat` | double | Fat amount (g) |
| `createdAt` | DateTime | Timestamp of creation |

## 6. Features Implementation Details

- **Offline Resilience**:
  - The app actively monitors network connectivity.
  - CRUD operations are handled optimistically, updating the UI immediately while syncing with Firestore in the background.
  - Images are cached locally to ensure they remain visible even when offline.

- **Security Rules (Firebase)**:
  - **Auth**: Users must be authenticated to read/write data.
  - **Firestore**: Data is scoped to the `userId`, ensuring users can only access their own meal logs.
