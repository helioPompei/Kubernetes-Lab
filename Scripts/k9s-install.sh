#!/bin/bash

set -e

echo "🔄 Fetching latest k9s release..."

# Get latest version from GitHub
LATEST_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)

if [ -z "$LATEST_VERSION" ]; then
  echo "❌ Failed to get latest version."
  exit 1
fi

echo "📦 Latest version: $LATEST_VERSION"

# Construct download URL
URL="https://github.com/derailed/k9s/releases/download/${LATEST_VERSION}/k9s_Linux_amd64.tar.gz"

# Download
echo "⬇️ Downloading $URL"
curl -LO "$URL"

# Extract
echo "📂 Extracting..."
tar -xzf k9s_Linux_amd64.tar.gz

# Move binary
echo "🚚 Installing to /usr/local/bin..."
sudo mv k9s /usr/local/bin/

# Clean up
rm k9s_Linux_amd64.tar.gz

# Verify
echo "✅ k9s installed/updated:"
k9s version
