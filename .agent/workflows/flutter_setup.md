---
description: Setup Flutter SDK on Windows and run the project
---

## Prerequisites
- Windows 10/11 (64‑bit)
- PowerShell (run as Administrator for some steps)
- Internet connection

## Steps
1. **Download Flutter SDK**
   - Open your web browser and go to the official Flutter download page: https://flutter.dev/docs/get-started/install/windows
   - Click **"Download Flutter SDK"** and save the zip file (e.g., `flutter_windows_3.22.0-stable.zip`).

2. **Extract the SDK**
   - Extract the zip to a location of your choice, e.g., `C:\src\flutter`.
   - Ensure the path does **not** contain spaces.

3. **Add Flutter to PATH**
   ```powershell
   # Run PowerShell as Administrator
   $env:Path += ";C:\src\flutter\bin"
   [Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::Machine)
   ```
   - Restart any open command‑prompt or PowerShell windows.

4. **Run Flutter Doctor**
   ```powershell
   flutter doctor
   ```
   - Follow any additional instructions shown (e.g., installing Android Studio, setting up Android SDK, etc.).

5. **Verify the project runs**
   - Navigate to your project directory:
   ```powershell
   cd "C:\Users\HP\OneDrive\Desktop\flutter\food_dirary"
   ```
   - Run the app:
   ```powershell
   flutter run
   ```
   - If you have a device/emulator connected, the app should launch.

## Optional: Enable Flutter in VS Code
- Install the **Flutter** and **Dart** extensions from the VS Code Marketplace.
- Open the project folder in VS Code and press **F5** to start debugging.

---
**Note**: If you already have Flutter installed, ensure the `flutter\bin` directory is in your system `PATH` and restart the terminal.
