# Jenkins Setup Guide for Windows

Complete guide to set up Jenkins CI/CD server locally on Windows for your Flutter project.

## 📋 Prerequisites

Before starting, ensure you have:
- **Windows 10/11** or Windows Server
- **Administrator access**
- **Internet connection**
- **Java 17 or higher** (JDK)
- **Git** installed

## 🚀 Quick Setup (Automated)

### Option 1: Using PowerShell Script

1. **Open PowerShell as Administrator**
   - Right-click PowerShell
   - Select "Run as Administrator"

2. **Run the setup script**
   ```powershell
   cd C:\Users\admin\Desktop\ciandcd-main
   .\jenkins-setup-windows.ps1
   ```

3. **Follow the prompts**
   - The script will install Jenkins and Flutter
   - It will configure PATH variables

### Option 2: Using Chocolatey (Recommended)

If you have Chocolatey installed:

```powershell
# Install Chocolatey (if not installed)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Jenkins
choco install jenkins -y

# Install Flutter
choco install flutter -y

# Install Java 17
choco install openjdk17 -y
```

## 📝 Manual Setup (Step-by-Step)

### Step 1: Install Java 17

1. **Download Java 17 JDK**
   - Visit: https://adoptium.net/
   - Download "Eclipse Temurin 17 (LTS)" for Windows x64
   - Run the installer

2. **Set JAVA_HOME**
   - Open "Environment Variables"
   - Add new System Variable:
     - Name: `JAVA_HOME`
     - Value: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot` (adjust path)
   - Add to PATH: `%JAVA_HOME%\bin`

3. **Verify Installation**
   ```powershell
   java -version
   ```

### Step 2: Install Jenkins

#### Method A: Using Jenkins WAR File

1. **Download Jenkins WAR**
   - Visit: https://www.jenkins.io/download/
   - Download "Generic Java package (.war)"
   - Save to: `C:\Program Files\Jenkins\jenkins.war`

2. **Create Jenkins Directory**
   ```powershell
   New-Item -ItemType Directory -Path "C:\Program Files\Jenkins" -Force
   ```

3. **Start Jenkins**
   ```powershell
   cd "C:\Program Files\Jenkins"
   java -jar jenkins.war --httpPort=8080
   ```

4. **Access Jenkins**
   - Open browser: http://localhost:8080
   - Get initial password from console output or:
     ```powershell
     type "C:\Users\YourUsername\.jenkins\secrets\initialAdminPassword"
     ```

#### Method B: Using Chocolatey

```powershell
choco install jenkins -y
```

Jenkins will install as a Windows service and start automatically.

#### Method C: Using Windows Installer

1. Download Jenkins Windows installer from: https://www.jenkins.io/download/
2. Run the installer
3. Follow the installation wizard
4. Jenkins will start as a Windows service

### Step 3: Initial Jenkins Configuration

1. **Unlock Jenkins**
   - Access http://localhost:8080
   - Enter initial admin password (from console or file)

2. **Install Plugins**
   - Select "Install suggested plugins"
   - Wait for installation to complete

3. **Create Admin User**
   - Fill in admin details
   - Save and continue

4. **Configure Jenkins URL**
   - Use default: http://localhost:8080
   - Click "Save and Finish"

### Step 4: Install Flutter

1. **Download Flutter SDK**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download Flutter SDK zip
   - Extract to: `C:\src\flutter`

2. **Add Flutter to PATH**
   - Open "Environment Variables"
   - Edit "Path" variable
   - Add: `C:\src\flutter\bin`

3. **Verify Installation**
   ```powershell
   flutter doctor
   ```

4. **Accept Licenses** (if needed)
   ```powershell
   flutter doctor --android-licenses
   ```

### Step 5: Configure Jenkins Global Tools

1. **Open Jenkins Dashboard**
   - Go to: http://localhost:8080

2. **Configure Global Tools**
   - Click "Manage Jenkins"
   - Click "Global Tool Configuration"

3. **Configure JDK**
   - Scroll to "JDK"
   - Click "Add JDK"
   - Name: `JDK-17`
   - JAVA_HOME: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot`
   - Click "Save"

4. **Configure Flutter** (if plugin available)
   - Scroll to "Flutter" (if installed)
   - Click "Add Flutter"
   - Name: `Flutter-Stable`
   - Installation directory: `C:\src\flutter`
   - Click "Save"

   **OR** Add Flutter to PATH in Jenkins:
   - Go to "Manage Jenkins" → "Configure System"
   - Find "Global properties" → "Environment variables"
   - Add: `PATH` = `C:\src\flutter\bin;%PATH%`

### Step 6: Install Required Jenkins Plugins

1. **Go to Plugin Manager**
   - Manage Jenkins → Manage Plugins → Available

2. **Install Plugins**
   - ✅ **Git Plugin**
   - ✅ **Pipeline Plugin**
   - ✅ **GitHub Plugin** (optional, for webhooks)
   - ✅ **Email Extension Plugin** (optional)
   - ✅ **HTML Publisher Plugin** (optional)
   - ✅ **Coverage Plugin** (optional)

3. **Restart Jenkins** (if prompted)

### Step 7: Create Pipeline Job

1. **Create New Job**
   - Click "New Item"
   - Enter name: `Flutter-CI-CD`
   - Select "Pipeline"
   - Click "OK"

2. **Configure Pipeline**
   - Scroll to "Pipeline" section
   - **Definition**: Select "Pipeline script from SCM"
   - **SCM**: Select "Git"
   - **Repository URL**: `https://github.com/YOUR_USERNAME/YOUR_REPO.git`
   - **Credentials**: Add if repository is private
   - **Branches to build**: `*/main` or `*/master`
   - **Script Path**: `Jenkinsfile`
   - Click "Save"

3. **Test Build**
   - Click "Build Now"
   - Watch build progress
   - Check console output

### Step 8: Configure GitHub Webhook (Optional)

1. **In GitHub Repository**
   - Go to Settings → Webhooks
   - Click "Add webhook"

2. **Configure Webhook**
   - **Payload URL**: `http://YOUR_IP:8080/github-webhook/`
     - For local testing, use: `http://localhost:8080/github-webhook/`
     - Or use ngrok for external access: `ngrok http 8080`
   - **Content type**: `application/json`
   - **Events**: Select "Just the push event"
   - Click "Add webhook"

3. **In Jenkins**
   - Manage Jenkins → Configure System
   - Find "GitHub" section
   - Add GitHub Server
   - Configure credentials if needed

## 🔧 Running Jenkins

### As Windows Service (Recommended)

If installed via installer or Chocolatey, Jenkins runs as a service:

```powershell
# Start Jenkins service
Start-Service Jenkins

# Stop Jenkins service
Stop-Service Jenkins

# Check status
Get-Service Jenkins
```

### Manually (WAR File)

```powershell
cd "C:\Program Files\Jenkins"
java -jar jenkins.war --httpPort=8080
```

## 📁 Important Directories

- **Jenkins Home**: `C:\Users\YourUsername\.jenkins`
- **Jenkins WAR**: `C:\Program Files\Jenkins\jenkins.war`
- **Flutter SDK**: `C:\src\flutter`
- **Java**: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot`

## 🐛 Troubleshooting

### Jenkins Won't Start

1. **Check Java Installation**
   ```powershell
   java -version
   ```

2. **Check Port 8080**
   ```powershell
   netstat -ano | findstr :8080
   ```
   If port is in use, change port:
   ```powershell
   java -jar jenkins.war --httpPort=8081
   ```

3. **Check Jenkins Logs**
   - Service: Check Windows Event Viewer
   - Manual: Check console output

### Flutter Not Found in Jenkins

1. **Verify Flutter Installation**
   ```powershell
   flutter doctor
   ```

2. **Add to Jenkins PATH**
   - Manage Jenkins → Configure System
   - Global properties → Environment variables
   - Add: `PATH` = `C:\src\flutter\bin;%PATH%`

3. **Restart Jenkins**

### Build Failures

1. **Check Console Output**
   - View detailed error messages in build logs

2. **Verify Dependencies**
   ```powershell
   flutter pub get
   flutter doctor
   ```

3. **Check Java Version**
   ```powershell
   java -version  # Should be 17+
   ```

### Permission Issues

1. **Run Jenkins as Administrator** (if needed)
   - Services → Jenkins → Properties
   - Log on tab → Select "Local System account"

2. **Check File Permissions**
   - Ensure Jenkins has read/write access to project directories

## 🔐 Security Considerations

1. **Change Default Port** (if needed)
   ```powershell
   java -jar jenkins.war --httpPort=8081
   ```

2. **Enable HTTPS** (for production)
   - Configure reverse proxy (nginx, IIS)
   - Use SSL certificates

3. **Restrict Access**
   - Configure firewall rules
   - Use Jenkins security settings

## 📊 Monitoring Jenkins

- **Dashboard**: http://localhost:8080
- **Build History**: View in job page
- **System Log**: Manage Jenkins → System Log
- **Plugin Manager**: Manage Jenkins → Manage Plugins

## 🎯 Next Steps

After setup:
1. ✅ Test your first build
2. ✅ Configure email notifications
3. ✅ Set up code signing for releases
4. ✅ Configure deployment pipelines
5. ✅ Add Slack/Teams notifications

## 📚 Resources

- [Jenkins Windows Installation](https://www.jenkins.io/doc/book/installing/windows/)
- [Flutter Windows Setup](https://docs.flutter.dev/get-started/install/windows)
- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)

## 💡 Tips

- Keep Jenkins updated regularly
- Backup Jenkins home directory periodically
- Use Jenkinsfile for version control
- Monitor disk space (builds can use lots of space)
- Use build retention policies to manage disk usage

