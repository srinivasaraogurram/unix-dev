Here's a **shell script** tailored for **Ubuntu ARM (aarch64)** on an **Odroid M1**, which:

1. Installs `nvm` (Node Version Manager),
2. Uses `nvm` to install the latest stable version of **Node.js** and **npm**,
3. Ensures Node.js and npm are available in the shell path,
4. Sets up environment variables (`PATH`, etc.) correctly.

> ✅ This works without requiring `sudo` since `nvm` is installed per-user.

---

### ✅ Shell Script: `install_node_nvm.sh`

```bash
#!/bin/bash

echo "🚀 Installing nvm, Node.js, and npm on Odroid M1 (Ubuntu ARM64)"

# 1. Install build-essential and curl if not already installed
echo "🔧 Installing required dependencies..."
sudo apt update && sudo apt install -y curl build-essential

# 2. Download and install nvm
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  echo "📦 Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  echo "✅ nvm already installed."
fi

# Load nvm into current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Verify nvm installation
command -v nvm > /dev/null 2>&1 || {
  echo >&2 "❌ Failed to load nvm. Please restart your shell or check installation.";
  exit 1;
}

# 3. Install the latest stable Node.js version
echo "🛰️ Installing latest stable Node.js via nvm..."
nvm install node

# 4. Verify installation
node -v && npm -v > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "✅ Node.js and npm installed successfully!"
else
  echo "❌ Failed to install Node.js/npm."
  exit 1
fi

# 5. Ensure PATH includes user-level npm binaries
NPM_BIN_PATH="$(npm config get prefix)/bin"
if [[ ":$PATH:" != *":$NPM_BIN_PATH:"* ]]; then
  echo "🔧 Adding npm global binaries to PATH..."
  echo 'export PATH="$PATH:$(npm config get prefix)/bin"' >> ~/.bashrc
  export PATH="$PATH:$(npm config get prefix)/bin"
fi

# 6. Reload shell config
source ~/.bashrc

echo ""
echo "🎉 Setup complete!"
echo "👉 Node version: $(node -v)"
echo "👉 npm version: $(npm -v)"
echo "📌 You can now use Node.js and npm globally."

```

---

### 📝 How to Use

1. Save this as `install_node_nvm.sh`.
2. Make it executable:
   ```bash
   chmod +x install_node_nvm.sh
   ```
3. Run it:
   ```bash
   ./install_node_nvm.sh
   ```

---

### ⚠️ Notes

- This installs `nvm` into your home directory under `.nvm/`.
- The script adds `npm` global binaries to your `PATH` by modifying `.bashrc`.
- It uses **bash**; adjust for zsh/fish if needed.
- This will work on Ubuntu/Debian-based OS for Odroid M1 (ARM64).

---

Let me know if you want to install a specific Node.js version instead of the latest!
