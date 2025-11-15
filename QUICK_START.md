# Jenkins Quick Start Guide

## ✅ Jenkins is Already Downloaded!

Jenkins WAR file has been downloaded to: `C:\Users\admin\Jenkins\jenkins.war`

## 📋 Prerequisites

### 1. Install Java 17 (Required)

Jenkins requires Java 17 or higher to run. Here are your options:

#### Option A: Download Java 17 JDK (Recommended)
1. Visit: https://adoptium.net/temurin/releases/
2. Download **Eclipse Temurin 17 (LTS)** for Windows x64
3. Run the installer
4. During installation, make sure to check "Add to PATH"
5. Verify installation:
   ```powershell
   java -version
   ```

#### Option B: Use Chocolatey (If you have it)
```powershell
choco install openjdk17 -y
```

#### Option C: Use Winget (Windows 10/11)
```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```

## 🚀 Starting Jenkins

### Method 1: Using the Batch Script (Easiest)
1. Make sure Java is installed and in your PATH
2. Double-click `start-jenkins.bat`
3. Jenkins will start on http://localhost:8080

### Method 2: Using PowerShell
```powershell
cd C:\Users\admin\Desktop\ciandcd-main
java -jar "$env:USERPROFILE\Jenkins\jenkins.war" --httpPort=8080
```

### Method 3: Using Command Prompt
```cmd
cd C:\Users\admin\Desktop\ciandcd-main
java -jar "%USERPROFILE%\Jenkins\jenkins.war" --httpPort=8080
```

## 🔓 First Time Setup

1. **Access Jenkins**
   - Open your browser: http://localhost:8080
   - You'll see the "Unlock Jenkins" page

2. **Get Initial Admin Password**
   - The password will be displayed in the console where Jenkins is running
   - OR find it in: `C:\Users\admin\.jenkins\secrets\initialAdminPassword`
   - Copy and paste the password

3. **Install Plugins**
   - Choose "Install suggested plugins" (recommended)
   - Wait for installation to complete

4. **Create Admin User**
   - Fill in your admin credentials
   - Click "Save and Continue"

5. **Configure Jenkins URL**
   - Use default: http://localhost:8080
   - Click "Save and Finish"

6. **Start Using Jenkins!**
   - Click "Start using Jenkins"

## 🛑 Stopping Jenkins

- If running in a console window: Press `Ctrl+C`
- If running as a service: Use `stop-jenkins.bat` (as Administrator)

## 📝 Next Steps

1. **Configure Global Tools** (Manage Jenkins → Global Tool Configuration)
   - Set up JDK path
   - Configure Flutter SDK (if needed)
   - Configure Git

2. **Create Your First Pipeline**
   - New Item → Pipeline
   - Point to your `Jenkinsfile` in this repository

3. **Install Additional Plugins** (if needed)
   - Git Plugin
   - Pipeline Plugin
   - GitHub Plugin (for webhooks)

## 🐛 Troubleshooting

### Java Not Found
- Make sure Java 17+ is installed
- Verify it's in your PATH: `java -version`
- Restart your terminal after installing Java

### Port 8080 Already in Use
- Change the port: `java -jar jenkins.war --httpPort=8081`
- Update the start script with the new port

### Jenkins Won't Start
- Check Java version: `java -version` (should be 17+)
- Check if port is available: `netstat -ano | findstr :8080`
- Check Jenkins logs in the console output

## 📚 More Information

- Full setup guide: `JENKINS_WINDOWS_SETUP.md`
- Quick reference: `JENKINS_QUICK_REFERENCE.md`
- Jenkins documentation: https://www.jenkins.io/doc/

