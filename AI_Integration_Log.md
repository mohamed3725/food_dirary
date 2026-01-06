# AI Integration Log - Food Diary App

This document outlines the usage of AI (Antigravity) during the development of the Food Diary Flutter application as part of the Mobile Application Development Final Exam Project.

## AI Tools Used
- **Antigravity (Google DeepMind)**: Primary coding assistant for architecture, UI design, and feature implementation.

## Prompts & Effectiveness

### 1. Project Initialization & Theme
- **Prompt**: "Create a modern Material 3 theme with Teal/Coral colors and Outfit font."
- **Effectiveness**: Highly effective. Provided a cohesive design system that set the tone for the entire app.
- **Modification**: Adjusted primary container colors to ensure better accessibility in dark mode.

### 2. Character to Meal Refactoring
- **Prompt**: "Refactor the Character model into a Meal model with nutrition properties."
- **Effectiveness**: Very effective. Renamed all related components (MealCard, MealRepository) consistently across the codebase.

### 3. Firebase Integration
- **Prompt**: "Connect the app to Firebase Firestore and Auth using real implementation instead of mock."
- **Effectiveness**: Effective. Guided through `google-services.json` setup and refactored `AuthService` to use `FirebaseAuth`.
- **Ethics**: Ensured security rules were discussed (though set to `if true` for rapid testing during development).

### 4. Advanced Features (Search, Share, Images)
- **Prompt**: "Implement search in HomeScreen, sharing in MealCard, image upload to Firebase Storage, and make it faster."
- **Effectiveness**: Excellent. Suggested using `share_plus`, `cached_network_image`, and implemented initial background uploading.

### 5. Offline Resilience & Persistence Fixes
- **Prompt**: "The app has issues with images disappearing after saving, and authentication fails with network errors. Fix these using an offline-first approach."
- **Effectiveness**: Highly effective. 
    - **Persistence**: Suggested and implemented local image caching using `path_provider` so images remain visible immediately while uploading.
    - **Network Errors**: Improved `AuthService` to catch specifically `network-request-failed` and provided clear UI feedback on `LoginScreen` via `ConnectivityProvider`.

## Challenges with AI Assistance
- **State Consistency**: Occasionally, AI suggestions for "Optimistic UI" required careful manual review to ensure error handling didn't leave the UI in an inconsistent state.
- **Dependency Versions**: AI initially suggested older versions of some packages; I manually updated `pubspec.yaml` to the latest versions for compatibility.

## Ethical Considerations
- **Learning vs. Generating**: While AI generated initial class structures and UI layouts, I (the student) reviewed and explained the logic, especially the State Management (Provider) and Firebase stream integration, to ensure full understanding.
- **Attribution**: All AI-assisted components are documented in this log and the project source code.

## Reflection
AI served as a "Pair Programmer," significantly accelerating the development of boilerplate code and providing best-practice suggestions for Material 3 design. The core technical decisions (State Management choice, Firebase structure) were made collaboratively.
