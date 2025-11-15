#!/bin/bash

# Jenkins Setup Script for Flutter CI/CD
# This script helps set up Jenkins for Flutter projects

set -e

echo "=========================================="
echo "Jenkins Flutter CI/CD Setup Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Warning: This script should be run with sudo for system-wide installation${NC}"
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for Jenkins
if ! command_exists jenkins; then
    echo -e "${YELLOW}Jenkins is not installed. Installing Jenkins...${NC}"
    
    # Detect OS
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        echo -e "${RED}Cannot detect OS. Please install Jenkins manually.${NC}"
        exit 1
    fi
    
    case $OS in
        ubuntu|debian)
            echo "Installing Jenkins on Ubuntu/Debian..."
            wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo apt-key add -
            sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
            sudo apt-get update
            sudo apt-get install -y jenkins
            ;;
        centos|rhel|fedora)
            echo "Installing Jenkins on CentOS/RHEL/Fedora..."
            sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
            sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
            sudo yum install -y jenkins
            ;;
        *)
            echo -e "${RED}Unsupported OS. Please install Jenkins manually.${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}Jenkins installed successfully!${NC}"
    echo "Get initial admin password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
else
    echo -e "${GREEN}Jenkins is already installed${NC}"
fi

# Install Flutter
FLUTTER_DIR="/opt/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
    echo -e "${YELLOW}Installing Flutter...${NC}"
    sudo mkdir -p /opt
    cd /opt
    sudo git clone https://github.com/flutter/flutter.git -b stable
    sudo chown -R jenkins:jenkins /opt/flutter 2>/dev/null || sudo chown -R $USER:$USER /opt/flutter
    
    # Add Flutter to PATH for Jenkins user
    if id "jenkins" &>/dev/null; then
        echo 'export PATH="$PATH:/opt/flutter/bin"' | sudo tee -a /var/lib/jenkins/.bashrc
    fi
    
    echo -e "${GREEN}Flutter installed at $FLUTTER_DIR${NC}"
else
    echo -e "${GREEN}Flutter is already installed at $FLUTTER_DIR${NC}"
fi

# Install Java (if not installed)
if ! command_exists java; then
    echo -e "${YELLOW}Installing Java 17...${NC}"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    fi
    
    case $OS in
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y openjdk-17-jdk
            ;;
        centos|rhel|fedora)
            sudo yum install -y java-17-openjdk-devel
            ;;
    esac
    echo -e "${GREEN}Java installed${NC}"
else
    echo -e "${GREEN}Java is already installed${NC}"
    java -version
fi

# Install required Jenkins plugins
echo -e "${YELLOW}Installing Jenkins plugins...${NC}"
echo "Please install these plugins manually from Jenkins UI:"
echo "  - Git Plugin"
echo "  - Pipeline Plugin"
echo "  - Email Extension Plugin (optional)"
echo "  - HTML Publisher Plugin (optional)"
echo "  - Coverage Plugin (optional)"
echo ""
echo "Or use Jenkins CLI:"
echo "  jenkins-plugin-cli --plugins git pipeline workflow-aggregator email-ext htmlpublisher"

# Setup Flutter for Jenkins user
if id "jenkins" &>/dev/null; then
    echo -e "${YELLOW}Configuring Flutter for Jenkins user...${NC}"
    sudo -u jenkins /opt/flutter/bin/flutter doctor || true
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Access Jenkins at http://localhost:8080"
echo "2. Get initial admin password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo "3. Install recommended plugins"
echo "4. Configure Global Tools:"
echo "   - Flutter SDK: /opt/flutter"
echo "   - JDK: Configure Java 17"
echo "5. Create a new Pipeline job"
echo "6. Point it to your GitHub repository with Jenkinsfile"
echo ""
echo "For detailed instructions, see README.md or .jenkins-setup.md"

