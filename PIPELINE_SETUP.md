# Jenkins CI/CD Pipeline Setup Guide

## ✅ Local Pipeline Test - SUCCESS!

Your CI/CD pipeline has been tested locally and all stages passed:
- ✓ Dependencies installed
- ✓ Code analysis passed
- ✓ Tests passed
- ✓ Android APK built successfully (18.4 MB)

## 🚀 Setting Up Jenkins Pipeline

### Prerequisites

1. **Java 17+** - Required for Jenkins
2. **Jenkins Server** - Running on http://localhost:8080
3. **Flutter SDK** - Installed and in PATH
4. **Git** - For source control

### Quick Start

#### Option 1: Automated Setup Script
```powershell
.\setup-jenkins-pipeline.ps1
```
This script will guide you through the setup process.

#### Option 2: Manual Setup

### Step 1: Start Jenkins

If Jenkins is not running:

```powershell
# Install Java 17 first if needed
# Then start Jenkins:
.\start-jenkins.bat
# OR
.\setup-and-start-jenkins.ps1
```

Access Jenkins at: http://localhost:8080

### Step 2: Install Required Plugins

1. Go to: **Manage Jenkins → Manage Plugins → Available**
2. Search and install:
   - ✅ **Git Plugin**
   - ✅ **Pipeline Plugin**
   - ✅ **Pipeline: Stage View Plugin**
   - ✅ **HTML Publisher Plugin** (for reports)
   - ✅ **Test Results Analyzer Plugin**
   - ✅ **Coverage Plugin** (optional, for test coverage)

3. Restart Jenkins if prompted

### Step 3: Configure Global Tools

1. Go to: **Manage Jenkins → Global Tool Configuration**

2. **Configure JDK:**
   - Click "Add JDK"
   - Name: `JDK-17`
   - JAVA_HOME: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot` (adjust to your path)
   - Or use "Install automatically"

3. **Configure Flutter:**
   - Option A: If Flutter plugin is installed
     - Add Flutter installation
     - Name: `Flutter-Stable`
     - Installation directory: `C:\src\flutter` (or your Flutter path)
   
   - Option B: Add to PATH
     - Go to: **Manage Jenkins → Configure System**
     - Find "Global properties" → "Environment variables"
     - Add: `PATH` = `C:\src\flutter\bin;%PATH%`

### Step 4: Create Pipeline Job

1. **Click "New Item"** on Jenkins dashboard

2. **Enter job name:** `Flutter-CI-CD`

3. **Select "Pipeline"** and click OK

4. **Configure Pipeline:**
   - Scroll to "Pipeline" section
   - **Definition:** Select "Pipeline script from SCM"
   - **SCM:** Select "Git"
   - **Repository URL:** 
     - For local repo: `file:///C:/Users/admin/Desktop/ciandcd-main`
     - For remote repo: `https://github.com/YOUR_USERNAME/YOUR_REPO.git`
   - **Credentials:** Add if repository is private
   - **Branches to build:** `*/main` or `*/master`
   - **Script Path:** 
     - `Jenkinsfile` (for Unix/Linux agents)
     - `Jenkinsfile.windows` (for Windows agents)

5. **Click "Save"**

### Step 5: Run Your First Build

1. Click **"Build Now"** on your pipeline job
2. Watch the build progress in real-time
3. Click on the build number to see details
4. Click **"Console Output"** to see full logs

### Step 6: View Results

After a successful build:
- **Build Artifacts:** Download APK from build page
- **Test Results:** View test reports
- **Coverage Reports:** View code coverage (if configured)

## 📁 Jenkinsfile Options

You have two Jenkinsfile options:

1. **Jenkinsfile** - Unix/Linux compatible (uses `sh` commands)
   - Works with Git Bash on Windows
   - Works with Linux agents
   - Works with WSL

2. **Jenkinsfile.windows** - Windows native (uses `bat` commands)
   - Optimized for Windows agents
   - Uses Windows batch commands
   - Better Windows path handling

## 🔧 Pipeline Stages

Your pipeline includes these stages:

1. **Checkout** - Gets code from repository
2. **Setup Flutter** - Verifies Flutter installation
3. **Get Dependencies** - Runs `flutter pub get`
4. **Code Analysis** - Runs `flutter analyze`
5. **Run Tests** - Runs `flutter test --coverage`
6. **Build Android APK** - Builds release APK (main/master/develop branches)
7. **Build Android App Bundle** - Builds AAB (main/master branches)

## 🧪 Testing Pipeline Locally

Before setting up Jenkins, you can test the pipeline locally:

```powershell
.\run-pipeline-locally.ps1
```

This runs all pipeline stages without Jenkins.

## 🐛 Troubleshooting

### Jenkins Won't Start
- Check Java installation: `java -version`
- Check port 8080: `netstat -ano | findstr :8080`
- See `QUICK_START.md` for detailed troubleshooting

### Pipeline Fails at Flutter Stage
- Verify Flutter is in PATH in Jenkins
- Check "Global Tool Configuration" for Flutter setup
- Add Flutter to Jenkins environment variables

### Build Fails
- Check console output for detailed errors
- Verify Android SDK is configured
- Check Flutter doctor output in Jenkins

### Tests Fail
- Review test output in console
- Check test files are in correct location
- Verify test dependencies are installed

## 📊 Monitoring Builds

- **Dashboard:** View all jobs and builds
- **Build History:** See past builds and their status
- **Console Output:** Detailed logs for each build
- **Test Results:** View test reports and trends
- **Artifacts:** Download built APKs and reports

## 🔔 Notifications (Optional)

Configure email notifications in Jenkins:
1. Install "Email Extension Plugin"
2. Configure SMTP in "Manage Jenkins → Configure System"
3. Uncomment email sections in Jenkinsfile

## 📚 Additional Resources

- **Jenkins Documentation:** https://www.jenkins.io/doc/
- **Pipeline Syntax:** https://www.jenkins.io/doc/book/pipeline/syntax/
- **Flutter CI/CD:** https://docs.flutter.dev/deployment/ci-cd

## ✅ Next Steps

1. ✅ Test pipeline locally (done!)
2. ⏳ Install Java 17
3. ⏳ Start Jenkins server
4. ⏳ Install required plugins
5. ⏳ Configure global tools
6. ⏳ Create pipeline job
7. ⏳ Run first build
8. ⏳ Configure notifications (optional)
9. ⏳ Set up webhooks for automatic builds (optional)

---

**Need Help?** Check the detailed guides:
- `QUICK_START.md` - Quick Jenkins setup
- `JENKINS_WINDOWS_SETUP.md` - Detailed Windows setup
- `JENKINS_QUICK_REFERENCE.md` - Quick reference

