Here's a **bash shell script** that will:

1. Install **SDKMAN!**
2. Use SDKMAN to install **Java 21 (GraalVM or OpenJDK)** for **ARM64 (aarch64)**
3. Set the installed Java as the default
4. Add `JAVA_HOME` to your environment (`PATH`, `CLASSPATH`, etc.)

This is tailored for **Ubuntu ARM on Odroid-M1 (ARM64/aarch64 architecture)**.

---

### ✅ Shell Script: `install_java_21_sdkman.sh`

```bash
#!/bin/bash

# Script to install SDKMAN and Java 21 on Odroid M1 (Ubuntu ARM64)

echo "Installing dependencies..."
sudo apt update && sudo apt install -y curl zip unzip gnupg git

# Check if SDKMAN is already installed
if [ -d "$HOME/.sdkman" ]; then
    echo "SDKMAN is already installed."
else
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash

    # Load SDKMAN environment
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Source SDKMAN for this session
export SDKMAN_DIR="$HOME/.sdkman"
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo "Updating available candidates..."
sdk selfupdate

# List available Java 21 versions (for user reference)
echo "Available Java 21 versions:"
sdk list java | grep '21'

# Choose appropriate candidate, e.g., 21-amzn (Amazon Corretto), 21-tem (Eclipse Temurin), or graalvm
DEFAULT_JAVA_VERSION="21-tem"

echo "Installing Java $DEFAULT_JAVA_VERSION..."
sdk install java $DEFAULT_JAVA_VERSION

# Confirm installation
if sdk use java $DEFAULT_JAVA_VERSION; then
    echo "Successfully set Java $DEFAULT_JAVA_VERSION as default."
else
    echo "Failed to set Java version. Please check available versions using 'sdk list java'"
    exit 1
fi

# Set JAVA_HOME and update PATH/CLASSPATH
JAVA_HOME_PATH=$(sdk home java $DEFAULT_JAVA_VERSION)

echo "Setting JAVA_HOME to $JAVA_HOME_PATH..."
export JAVA_HOME="$JAVA_HOME_PATH"
export PATH="$JAVA_HOME/bin:$PATH"
export CLASSPATH=".:$JAVA_HOME/lib:$JAVA_HOME/jre/lib"

# Persist environment variables in .bashrc or .zshrc
SHELL_CONFIG_FILE="$HOME/.bashrc"
if [[ "$(basename "$SHELL")" == "zsh" ]]; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
fi

{
    echo '# SDKMAN & Java Environment'
    echo "export SDKMAN_DIR=\"$HOME/.sdkman\""
    echo "source \"$HOME/.sdkman/bin/sdkman-init.sh\""
    echo "export JAVA_HOME=\"$JAVA_HOME_PATH\""
    echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\""
    echo "export CLASSPATH=.:\"\$JAVA_HOME/lib\":\"\$JAVA_HOME/jre/lib\""
} >> "$SHELL_CONFIG_FILE"

echo ""
echo "✅ Java 21 has been installed and configured!"
echo "Restart your shell or run 'source $SHELL_CONFIG_FILE' to apply changes."
echo "Verify with: java -version"
```

---

### 📝 Notes:

- This script assumes you're using **bash** or **zsh**, and it appends the environment variables to `.bashrc` or `.zshrc`.
- It installs **Eclipse Temurin 21** (`21-tem`) by default. You can change the version by modifying the `DEFAULT_JAVA_VERSION` variable.
- Supported vendors via SDKMAN include:
  - `21-amzn` – Amazon Corretto
  - `21-azul` – Zulu (Azul)
  - `21-grl` – GraalVM CE
  - `21-ibm` – IBM Semeru
  - `21-tem` – Eclipse Temurin (default in script)

You can list all options with:
```bash
sdk list java | grep '21'
```

---

### 🔐 Run the Script

Make it executable and run:

```bash
chmod +x install_java_21_sdkman.sh
./install_java_21_sdkman.sh
```

After running, restart your shell or source your config:

```bash
source ~/.bashrc   # or ~/.zshrc
```

Then verify:

```bash
java -version
echo $JAVA_HOME
```

Let me know if you want to install **GraalVM Native Image** or other tools too!
