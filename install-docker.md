To install **Docker** on an **Ubuntu ARM64 system running on ODROID-M1**, follow these steps. The ODROID-M1 uses an ARM64 (aarch64) processor, so we'll use the official Docker installation methods that support ARM architectures.

---

## ✅ Step-by-step: Install Docker on Ubuntu (ARM64) for ODROID-M1

### 📌 1. Update your system
```bash
sudo apt update && sudo apt upgrade -y
```

### 📌 2. Install required packages
```bash
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common
```

### 📌 3. Add Docker’s official GPG key
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

### 📌 4. Add Docker APT repository
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 📌 5. Update package index again
```bash
sudo apt update
```

### 📌 6. Install Docker Engine
```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### 📌 7. Verify Docker installation
```bash
sudo docker --version
sudo docker info
```

### 📌 8. Test Docker with Hello World
```bash
sudo docker run hello-world
```

> 💡 If you see a "Hello from Docker!" message, then Docker is installed correctly!

---

## 🧑‍💻 Optional: Manage Docker as a non-root user

Add your user to the `docker` group:
```bash
sudo usermod -aG docker $USER
```

Log out and back in for the group changes to take effect.

---

## 🔁 Optional: Enable Docker to start on boot
```bash
sudo systemctl enable docker
```

---

## 🐘 Notes about ARM64 (ODROID-M1)

- The ODROID-M1 runs native **ARM64 (aarch64)** architecture.
- Most modern Docker images have multi-arch support (including ARM64), especially official ones like `nginx`, `redis`, `python`, etc.
- You can build or pull ARM64-specific images using tags like `--platform linux/arm64`.

Example:
```bash
docker run --platform linux/arm64 nginx
```

---

## ❓ Troubleshooting

If you encounter issues:

- Make sure you're using a **64-bit version of Ubuntu** (most ODROID images are).
- Check kernel version: `uname -a`
- Ensure your OS is up-to-date.
- Use `journalctl -u docker.service` to debug Docker service startup issues.

---

Let me know if you'd like help installing **Docker Compose** too!
