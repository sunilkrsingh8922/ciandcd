# ciandcd

A new Flutter project with CI/CD setup using Codemagic.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features

- **Flutter Application**: Standard Flutter app with Material Design
- **2D Game Development**: Integrated with [Flame 2D Engine](https://flame-engine.org/) for game development
- **CI/CD**: Automated testing and building with Codemagic

## 2D Game Development with Flame

This project includes support for developing 2D games using the Flame engine.

### Flame Engine Setup

The project includes:
- **Flame dependency**: Added to `pubspec.yaml`
- **Example game**: A simple 2D game with player movement
- **Game components**: Player, World, and MainGame classes

### Running the Game

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

3. Click the "Play 2D Game (Flame Engine)" button to launch the game

4. Use **Arrow Keys** or **WASD** to move the player

### Game Structure

```
lib/
  ├── game/
  │   ├── main_game.dart    # Main game class
  │   ├── player.dart        # Player component
  │   └── world.dart         # World/environment component
  └── game_page.dart         # Game page widget
```

### Extending the Game

You can extend the game by:
- Adding more components (enemies, collectibles, etc.)
- Implementing collision detection
- Adding sprites and animations
- Creating levels and game states
- Adding sound effects and music

### Flame Resources

- [Flame Documentation](https://docs.flame-engine.org/)
- [Flame Examples](https://examples.flame-engine.org/)
- [Flame GitHub](https://github.com/flame-engine/flame)

## CI/CD with Codemagic

This project is configured with Codemagic for continuous integration and continuous deployment.

### Setup Instructions

1. **Create a Codemagic account**
   - Go to [codemagic.io](https://codemagic.io)
   - Sign up with your GitHub/GitLab/Bitbucket account

2. **Connect your repository**
   - In Codemagic dashboard, click "Add application"
   - Select your repository (this project)
   - Codemagic will automatically detect the `codemagic.yaml` file

3. **Configure workflows**
   - The `codemagic.yaml` file includes multiple workflows:
     - **test-workflow**: Runs tests and code analysis
     - **android-workflow**: Builds Android APK
     - **android-aab-workflow**: Builds Android App Bundle (for Play Store)
     - **ios-workflow**: Builds iOS app (requires code signing setup)

4. **Update email notifications**
   - Edit `codemagic.yaml` and replace `user@example.com` with your email address
   - Or configure email notifications in Codemagic dashboard

5. **Configure code signing (for iOS/Android releases)**
   - For Android: Add your keystore file and credentials as environment variables
   - For iOS: Add your certificates and provisioning profiles
   - See [Codemagic documentation](https://docs.codemagic.io/code-signing/) for details

6. **Start building**
   - Push your code to trigger builds automatically
   - Or manually trigger builds from the Codemagic dashboard

### Workflow Details

- **Test Workflow**: Runs on every push/PR, executes `flutter analyze` and `flutter test`
- **Android Workflow**: Builds release APK after successful tests
- **Android AAB Workflow**: Builds App Bundle for Google Play Store
- **iOS Workflow**: Builds iOS app (requires proper code signing configuration)

### Resources

- [Codemagic Documentation](https://docs.codemagic.io/)
- [Flutter CI/CD Best Practices](https://docs.codemagic.io/flutter/flutter-ci-cd/)
