# Jenkins CI/CD Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

### Option 1: Using Docker (Recommended for Testing)

```bash
# Run Jenkins in Docker
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Get initial password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Access Jenkins at: http://localhost:8080

### Option 2: Local Installation

```bash
# Run setup script
chmod +x jenkins-setup.sh
sudo ./jenkins-setup.sh
```

## 📋 Step-by-Step Configuration

### 1. Initial Jenkins Setup

1. **Access Jenkins**
   - Open http://localhost:8080 (or your Jenkins URL)
   - Enter initial admin password (from setup script or Docker logs)

2. **Install Plugins**
   - Select "Install suggested plugins"
   - Or manually install:
     - Git
     - Pipeline
     - GitHub Integration (optional)

3. **Create Admin User**
   - Set up your admin account

### 2. Configure Global Tools

1. Go to **Manage Jenkins** → **Global Tool Configuration**

2. **Configure JDK**
   - Name: `JDK-17`
   - JAVA_HOME: `/usr/lib/jvm/java-17-openjdk-amd64` (Linux) or your Java path

3. **Configure Flutter** (if plugin available)
   - Name: `Flutter-Stable`
   - Installation directory: `/opt/flutter`
   - Or add to PATH in Jenkins environment

### 3. Create Pipeline Job

1. **New Item**
   - Click "New Item" in Jenkins dashboard
   - Name: `Flutter-CI-CD`
   - Type: **Pipeline**
   - Click OK

2. **Configure Pipeline**
   ```
   Pipeline Configuration:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: https://github.com/YOUR_USERNAME/YOUR_REPO.git
   - Credentials: (Add if private repo)
   - Branches: */main (or */master)
   - Script Path: Jenkinsfile
   ```

3. **Save and Build**
   - Click "Save"
   - Click "Build Now"

### 4. Set Up GitHub Webhook (Automatic Builds)

1. **In GitHub:**
   - Go to your repository → Settings → Webhooks
   - Click "Add webhook"
   - Payload URL: `http://YOUR_JENKINS_IP:8080/github-webhook/`
   - Content type: `application/json`
   - Events: "Just the push event"
   - Click "Add webhook"

2. **In Jenkins:**
   - Manage Jenkins → Configure System
   - GitHub section → Add GitHub Server
   - Configure credentials if needed

## 🔧 Troubleshooting

### Flutter Not Found

```bash
# Install Flutter on Jenkins server
sudo mkdir -p /opt
cd /opt
sudo git clone https://github.com/flutter/flutter.git -b stable
sudo chown -R jenkins:jenkins /opt/flutter

# Add to PATH
export PATH="$PATH:/opt/flutter/bin"
```

### Build Failures

1. Check console output for errors
2. Verify Flutter installation: `flutter doctor`
3. Check Java version: `java -version` (should be 17+)
4. Ensure dependencies: `flutter pub get`

### Permission Issues

```bash
# Fix permissions
sudo chown -R jenkins:jenkins /opt/flutter
sudo chown -R jenkins:jenkins /path/to/android/sdk
```

## 📦 Pipeline Stages

The Jenkinsfile includes:

1. ✅ **Checkout** - Gets code from GitHub
2. ✅ **Setup Flutter** - Verifies Flutter installation
3. ✅ **Get Dependencies** - Installs Flutter packages
4. ✅ **Code Analysis** - Runs `flutter analyze`
5. ✅ **Run Tests** - Executes tests with coverage
6. ✅ **Build Android APK** - Creates release APK
7. ✅ **Build Android AAB** - Creates App Bundle

## 📧 Email Notifications

To enable email notifications:

1. Install **Email Extension Plugin**
2. Configure SMTP in Jenkins:
   - Manage Jenkins → Configure System
   - Extended E-mail Notification section
3. Uncomment email sections in Jenkinsfile
4. Update email address in Jenkinsfile

## 🎯 Next Steps

- [ ] Set up code signing for release builds
- [ ] Configure deployment to app stores
- [ ] Add Slack/Teams notifications
- [ ] Set up build schedules
- [ ] Configure parallel builds
- [ ] Add iOS build support

## 📚 Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)

