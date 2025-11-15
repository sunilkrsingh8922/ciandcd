# Jenkins CI/CD Configuration Guide

## ✅ Jenkins Status

**Jenkins Service:** Running  
**Port:** 8080  
**URL:** http://localhost:8080

## 🚀 Quick Start Configuration

### Step 1: Access Jenkins Dashboard

1. Open your web browser
2. Navigate to: **http://localhost:8080**
3. If this is your first time, you'll need the initial admin password

**Get Initial Admin Password:**
```powershell
# Check Jenkins home directory
Get-Content "$env:USERPROFILE\.jenkins\secrets\initialAdminPassword"
```

OR check the Jenkins service logs:
```powershell
Get-EventLog -LogName Application -Source Jenkins -Newest 5 | Select-Object Message
```

### Step 2: Install Required Plugins

After unlocking Jenkins:

1. Click **"Manage Jenkins"** → **"Manage Plugins"** → **"Available"** tab
2. Search and install these plugins:
   - ✅ **Git Plugin** (essential)
   - ✅ **Pipeline Plugin** (essential)
   - ✅ **Pipeline: Stage View Plugin** (for visual pipeline view)
   - ✅ **HTML Publisher Plugin** (for reports)
   - ✅ **Test Results Analyzer Plugin** (for test reports)
   - ✅ **Coverage Plugin** (optional, for code coverage)

3. Click **"Install without restart"** or **"Install and restart"**
4. Wait for installation to complete

### Step 3: Configure Global Tools

#### Configure Java (JDK)

1. Go to: **Manage Jenkins** → **Global Tool Configuration**
2. Scroll to **JDK** section
3. Click **"Add JDK"**
4. Configure:
   - **Name:** `JDK-17`
   - **JAVA_HOME:** (find your Java installation)

**Find Java Installation:**
```powershell
# Check common Java locations
Get-ChildItem "C:\Program Files\Java" -ErrorAction SilentlyContinue
Get-ChildItem "C:\Program Files\Eclipse Adoptium" -ErrorAction SilentlyContinue
Get-ChildItem "C:\Program Files (x86)\Java" -ErrorAction SilentlyContinue
```

#### Configure Flutter

**Option A: Add Flutter to PATH (Recommended)**

1. Go to: **Manage Jenkins** → **Configure System**
2. Scroll to **Global properties**
3. Check **"Environment variables"**
4. Click **"Add"**
5. Configure:
   - **Name:** `PATH`
   - **Value:** `C:\src\flutter\bin;%PATH%`
   - (Adjust path to your Flutter installation)

**Find Flutter Path:**
```powershell
# If Flutter is in PATH
(Get-Command flutter).Source

# Common Flutter locations:
# C:\src\flutter\bin
# C:\flutter\bin
```

**Option B: Use Flutter Plugin (if installed)**

1. In **Global Tool Configuration**
2. Scroll to **Flutter** section
3. Click **"Add Flutter"**
4. Configure:
   - **Name:** `Flutter-Stable`
   - **Installation directory:** `C:\src\flutter` (or your path)

### Step 4: Create Pipeline Job

1. **Click "New Item"** on Jenkins dashboard

2. **Enter job name:** `Flutter-CI-CD`

3. **Select "Pipeline"** and click **OK**

4. **Configure Pipeline:**
   - Scroll to **"Pipeline"** section
   - **Definition:** Select **"Pipeline script from SCM"**
   - **SCM:** Select **"Git"**
   - **Repository URL:** 
     ```
     file:///C:/Users/admin/Desktop/ciandcd-main
     ```
     OR use your Git repository URL if using remote repo
   - **Credentials:** Leave empty for local repo, add for remote private repos
   - **Branches to build:** `*/main` or `*/master`
   - **Script Path:** `Jenkinsfile.windows`
     - This uses the Windows-compatible version
     - For Unix/Linux, use `Jenkinsfile`

5. **Click "Save"**

### Step 5: Run Your First Build

1. On your pipeline job page, click **"Build Now"**
2. Watch the build progress in the **Stage View**
3. Click on the **build number** (#1, #2, etc.) to see details
4. Click **"Console Output"** to see full build logs

## 📋 Pipeline Stages

Your CI/CD pipeline includes:

1. **Checkout** - Gets code from repository
2. **Setup Flutter** - Verifies Flutter installation
3. **Get Dependencies** - Runs `flutter pub get`
4. **Code Analysis** - Runs `flutter analyze`
5. **Run Tests** - Runs `flutter test --coverage`
6. **Build Android APK** - Builds release APK (main/master/develop branches)
7. **Build Android App Bundle** - Builds AAB (main/master branches)

## 🔧 Troubleshooting

### Jenkins Not Accessible

If http://localhost:8080 doesn't load:

1. **Check Jenkins service:**
   ```powershell
   Get-Service Jenkins
   ```

2. **Restart Jenkins service:**
   ```powershell
   Restart-Service Jenkins
   ```

3. **Check port 8080:**
   ```powershell
   Get-NetTCPConnection -LocalPort 8080
   ```

4. **Check Jenkins logs:**
   - Windows Event Viewer → Applications → Jenkins
   - OR: `C:\Program Files\Jenkins\jenkins.err.log`

### Pipeline Fails at Flutter Stage

**Error:** "Flutter not found in PATH"

**Solution:**
1. Verify Flutter is installed: `flutter --version`
2. Add Flutter to Jenkins PATH (Step 3 above)
3. Restart Jenkins after adding PATH

### Pipeline Fails at Build Stage

**Error:** Android build fails

**Solution:**
1. Verify Android SDK is installed
2. Set ANDROID_HOME in Jenkins environment variables:
   - **Manage Jenkins** → **Configure System**
   - **Global properties** → **Environment variables**
   - Add: `ANDROID_HOME` = `C:\Users\YourUser\AppData\Local\Android\Sdk`

### Java Not Found

**Error:** Java not found in Jenkins

**Solution:**
1. Find Java installation (see Step 3)
2. Configure JDK in Global Tool Configuration
3. Set JAVA_HOME correctly

## 📁 Files Reference

- **Jenkinsfile.windows** - Windows-compatible pipeline (use this for Windows)
- **Jenkinsfile** - Unix/Linux compatible pipeline
- **configure-jenkins-cicd.ps1** - Automated configuration script
- **run-pipeline-locally.ps1** - Test pipeline without Jenkins

## 🎯 Next Steps After Configuration

1. ✅ Run your first build
2. ✅ Check build artifacts (APK files)
3. ✅ Review test results
4. ✅ Set up build triggers (optional)
   - Poll SCM (check for changes periodically)
   - GitHub webhooks (automatic builds on push)
5. ✅ Configure notifications (optional)
   - Email notifications
   - Slack/Teams integration

## 📚 Additional Resources

- **Jenkins Documentation:** https://www.jenkins.io/doc/
- **Pipeline Syntax:** https://www.jenkins.io/doc/book/pipeline/syntax/
- **Flutter CI/CD:** https://docs.flutter.dev/deployment/ci-cd

## 💡 Tips

- Keep Jenkins updated regularly
- Monitor disk space (builds can use lots of space)
- Use build retention policies to manage disk usage
- Backup Jenkins configuration periodically
- Use Jenkinsfile for version control of your pipeline

---

**Need Help?** Run the configuration script:
```powershell
.\configure-jenkins-cicd.ps1
```

