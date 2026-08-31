#!/bin/sh

# PeDitXOSui Theme Installer
# Version: 1.0.0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print messages
print_msg() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Function to install a theme from a GitHub repository
install_theme() {
  local REPO_NAME=$1
  local THEME_NAME=$2

  echo ""
  print_msg "Processing $THEME_NAME..."

  # GitHub repository URL and package name
  LATEST_RELEASE_URL="https://api.github.com/repos/peditx/$REPO_NAME/releases/latest"
  IPK_URL=$(curl -s "$LATEST_RELEASE_URL" | grep "browser_download_url.*ipk" | cut -d '"' -f 4)

  # Check if the download link is found
  if [ -z "$IPK_URL" ]; then
    print_error "Download link for the .ipk file of $THEME_NAME not found."
    return 1
  fi

  # Download the .ipk package
  print_msg "Downloading the latest version of $THEME_NAME..."
  wget -q "$IPK_URL" -O "/tmp/$THEME_NAME.ipk"

  if [ $? -ne 0 ]; then
    print_error "Failed to download $THEME_NAME"
    return 1
  fi

  # Install the .ipk package
  print_msg "Installing $THEME_NAME..."
  opkg install "/tmp/$THEME_NAME.ipk"

  if [ $? -ne 0 ]; then
    print_error "Failed to install $THEME_NAME"
    rm -f "/tmp/$THEME_NAME.ipk"
    return 1
  fi

  # Clean up the downloaded file
  rm -f "/tmp/$THEME_NAME.ipk"

  print_msg "$THEME_NAME installed successfully."
}

# Main installation
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           PeDitXOSui Theme Installer v1.0.0              ║"
echo "║         Modern LuCI Theme for OpenWrt                    ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$(id -u)" != "0" ]; then
    print_error "This script must be run as root (use sudo)"
    exit 1
fi

# Install luci-theme-peditxosui
install_theme "luci-theme-peditxosui" "luci-theme-peditxosui"

if [ $? -eq 0 ]; then
    # Remove the default theme (optional)
    print_warn "Removing default Bootstrap theme..."
    opkg remove luci-theme-bootstrap --force-depends 2>/dev/null

    # Restart the web service to apply the changes
    print_msg "Restarting uhttpd service to apply changes..."
    /etc/init.d/uhttpd restart

    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    Installation Complete!                 ║"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  Theme: PeDitXOSui                                        ║"
    echo "║  Version: 1.0.0                                           ║"
    echo "║                                                           ║"
    echo "║  Access your router at:                                   ║"
    echo "║  http://192.168.1.1                                       ║"
    echo "║                                                           ║"
    echo "║  Features:                                                ║"
    echo "║  • Dark & Light Mode                                      ║"
    echo "║  • Responsive Design                                      ║"
    echo "║  • Modern Dashboard                                       ║"
    echo "║  • Bottom Navigation Bar                                  ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
else
    print_error "Installation failed. Please check your internet connection and try again."
    exit 1
fi

echo "Done."
