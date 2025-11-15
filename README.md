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
- **CI/CD**: Automated testing and building with Codemagic and Jenkins

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

## CI/CD with Jenkins

This project is also configured with Jenkins for continuous integration and continuous deployment using GitHub.

### Quick Setup for Windows

**Option 1: Automated Setup (Recommended)**
```powershell
# Run as Administrator
.\jenkins-setup-windows.ps1
```

**Option 2: Using Chocolatey**
```powershell
choco install jenkins flutter openjdk17 -y
```

**Option 3: Manual Setup**
See [JENKINS_WINDOWS_SETUP.md](JENKINS_WINDOWS_SETUP.md) for detailed step-by-step instructions.

### Quick Start

1. **Start Jenkins**
   ```powershell
   .\start-jenkins.bat
   # Or if installed as service:
   Start-Service Jenkins
   ```

2. **Access Jenkins**
   - Open: http://localhost:8080
   - Get password: `type "$env:USERPROFILE\.jenkins\secrets\initialAdminPassword"`

3. **Configure Pipeline**
   - Create new Pipeline job
   - Point to your GitHub repository
   - Use `Jenkinsfile` from this repo

For complete setup instructions, see [JENKINS_WINDOWS_SETUP.md](JENKINS_WINDOWS_SETUP.md).

### Prerequisites

1. **Jenkins Server**
   - Install Jenkins on your server or use Jenkins cloud service
   - Ensure Jenkins has access to your GitHub repository

2. **Required Plugins**
   - Install the following Jenkins plugins:
     - **Git Plugin**: For GitHub integration
     - **Pipeline Plugin**: For Jenkinsfile support
     - **Email Extension Plugin**: For email notifications (optional)
     - **HTML Publisher Plugin**: For test reports (optional)
     - **Coverage Plugin**: For code coverage reports (optional)

3. **Tools Configuration**
   - **Flutter SDK**: Install Flutter on Jenkins server or configure Flutter path
   - **Java JDK**: Install Java 17 or higher
   - **Android SDK**: Required for Android builds (optional, can use Flutter's bundled SDK)

### Setup Instructions

1. **Install Flutter on Jenkins Server**
   ```bash
   # On Jenkins server
   cd /opt
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:/opt/flutter/bin"
   flutter doctor
   ```

2. **Configure Jenkins Global Tools**
   - Go to **Manage Jenkins** → **Global Tool Configuration**
   - Configure Flutter SDK path (e.g., `/opt/flutter`)
   - Configure JDK installation (Java 17)

3. **Create Jenkins Pipeline Job**
   - Click **New Item** in Jenkins dashboard
   - Enter job name (e.g., "Flutter CI/CD")
   - Select **Pipeline** as job type
   - Click **OK**

4. **Configure Pipeline**
   - In **Pipeline** section:
     - **Definition**: Select "Pipeline script from SCM"
     - **SCM**: Select "Git"
     - **Repository URL**: Enter your GitHub repository URL
     - **Credentials**: Add GitHub credentials if repository is private
     - **Branches to build**: Specify branch (e.g., `*/main` or `*/master`)
     - **Script Path**: Enter `Jenkinsfile`
   - Click **Save**

5. **Configure GitHub Webhook (Optional)**
   - In your GitHub repository:
     - Go to **Settings** → **Webhooks** → **Add webhook**
     - **Payload URL**: `http://your-jenkins-server:8080/github-webhook/`
     - **Content type**: `application/json`
     - **Events**: Select "Just the push event"
     - Click **Add webhook**
   - This will trigger builds automatically on every push

6. **Configure Email Notifications (Optional)**
   - Install **Email Extension Plugin**
   - In Jenkinsfile, uncomment the `emailext` sections
   - Configure SMTP settings in Jenkins:
     - **Manage Jenkins** → **Configure System** → **Extended E-mail Notification**
   - Update email address in Jenkinsfile

### Jenkinsfile Overview

The `Jenkinsfile` includes the following stages:

1. **Checkout**: Checks out code from GitHub
2. **Setup Flutter**: Verifies Flutter installation
3. **Get Dependencies**: Runs `flutter pub get`
4. **Code Analysis**: Runs `flutter analyze`
5. **Run Tests**: Runs `flutter test` with coverage
6. **Build Android APK**: Builds release APK (on main/master/develop branches)
7. **Build Android App Bundle**: Builds AAB for Play Store (on main/master branches)

### Pipeline Features

- **Automatic builds** on push to configured branches
- **Test execution** with coverage reports
- **Code analysis** to catch issues early
- **Artifact archiving** for APK and AAB files
- **Email notifications** (when configured)
- **Test result publishing** and coverage reports

### Manual Build Trigger

You can manually trigger builds:
- Go to your Jenkins job
- Click **Build Now**

### Viewing Build Results

- **Console Output**: View detailed build logs
- **Test Results**: View test reports (if HTML Publisher plugin is installed)
- **Coverage Reports**: View code coverage (if Coverage plugin is installed)
- **Artifacts**: Download built APK/AAB files from build page

### Troubleshooting

1. **Flutter not found**
   - Ensure Flutter is installed and in PATH
   - Or configure Flutter path in Jenkins Global Tool Configuration

2. **Build failures**
   - Check console output for detailed error messages
   - Ensure all dependencies are properly configured
   - Verify Flutter and Java versions are correct

3. **GitHub webhook not working**
   - Verify webhook URL is accessible from GitHub
   - Check Jenkins logs for webhook events
   - Ensure GitHub credentials are configured correctly

### Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Flutter CI/CD with Jenkins](https://docs.flutter.dev/deployment/cd)
- [GitHub Integration with Jenkins](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#working-with-the-github-plugin)
