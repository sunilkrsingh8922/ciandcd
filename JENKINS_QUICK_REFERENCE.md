# Jenkins Quick Reference - Windows

## 🚀 Quick Start Commands

### Install Jenkins (Chocolatey)
```powershell
choco install jenkins -y
```

### Start Jenkins
```powershell
# As Windows Service
Start-Service Jenkins

# Or manually
.\start-jenkins.bat
```

### Stop Jenkins
```powershell
# As Windows Service
Stop-Service Jenkins

# Or manually
.\stop-jenkins.bat
```

### Access Jenkins
```
http://localhost:8080
```

### Get Initial Password
```powershell
type "$env:USERPROFILE\.jenkins\secrets\initialAdminPassword"
```

## 📋 Setup Checklist

- [ ] Install Java 17 JDK
- [ ] Install Jenkins
- [ ] Install Flutter SDK
- [ ] Configure Jenkins Global Tools
- [ ] Install Jenkins Plugins (Git, Pipeline)
- [ ] Create Pipeline Job
- [ ] Configure GitHub Webhook (optional)
- [ ] Test First Build

## 🔗 Important URLs

- **Jenkins Dashboard**: http://localhost:8080
- **Plugin Manager**: http://localhost:8080/pluginManager/
- **Global Tools**: http://localhost:8080/configureTools/
- **System Configuration**: http://localhost:8080/configure

## 📁 Key Directories

- **Jenkins Home**: `C:\Users\YourUsername\.jenkins`
- **Flutter SDK**: `C:\src\flutter`
- **Java**: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot`

## 🛠️ Common Commands

### Check Jenkins Status
```powershell
Get-Service Jenkins
```

### View Jenkins Logs
```powershell
# Service logs
Get-EventLog -LogName Application -Source Jenkins

# Or check: C:\Users\YourUsername\.jenkins\logs\
```

### Restart Jenkins
```powershell
Restart-Service Jenkins
```

### Check Port 8080
```powershell
netstat -ano | findstr :8080
```

### Verify Flutter
```powershell
flutter doctor
```

### Verify Java
```powershell
java -version
```

## 🔧 Troubleshooting

### Jenkins Won't Start
1. Check Java: `java -version`
2. Check port: `netstat -ano | findstr :8080`
3. Check logs: `C:\Users\YourUsername\.jenkins\logs\`

### Flutter Not Found
1. Verify: `flutter doctor`
2. Add to PATH in Jenkins environment variables
3. Restart Jenkins

### Build Fails
1. Check console output
2. Verify: `flutter pub get`
3. Check Java version (must be 17+)

## 📚 Documentation Files

- **JENKINS_WINDOWS_SETUP.md** - Complete setup guide
- **JENKINS_QUICKSTART.md** - Quick start guide
- **README.md** - Main documentation

