Absolutely! Here's a consolidated step-by-step guide to set up **code-server** on your Odroid M1 Ubuntu ARM device, proxy it securely with **Caddy**, and resolve all encountered issues:

---

# Complete Setup & Troubleshooting Guide: code-server + Caddy on Ubuntu ARM (Odroid M1)

---

## 1. **Install and run code-server**

* Make sure code-server is running on port 3000 with HTTPS enabled (default):

```bash
code-server --port 3000
```

(or your usual startup command)

---

## 2. **Install Caddy manually (latest ARM binary)**

Download and install latest official Caddy binary for ARM64:

```bash
curl -LO https://github.com/caddyserver/caddy/releases/latest/download/caddy_2.7.6_linux_arm64.tar.gz
tar -xzf caddy_2.7.6_linux_arm64.tar.gz
sudo install caddy /usr/local/bin/
```

Verify version:

```bash
caddy version
```

---

## 3. **Create Caddy user and directories**

```bash
sudo useradd --system --home /var/lib/caddy --shell /usr/sbin/nologin caddy
sudo mkdir -p /etc/caddy /var/lib/caddy /var/log/caddy
sudo chown -R caddy:caddy /etc/caddy /var/lib/caddy /var/log/caddy
```

---

## 4. **Prepare Caddyfile**

Create `/etc/caddy/Caddyfile` with:

```caddyfile
192.168.68.102:443 {
    reverse_proxy https://localhost:3000 {
        transport http {
            tls_insecure_skip_verify
        }
    }
    tls internal
}
```

> Replace `192.168.68.102` with your device's LAN IP.

---

## 5. **Set permissions to bind ports < 1024**

Allow Caddy binary to bind privileged ports 80 and 443:

```bash
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
```

---

## 6. **Create systemd service for Caddy**

Create file `/etc/systemd/system/caddy.service` with:

```ini
[Unit]
Description=Caddy Web Server
After=network.target

[Service]
User=caddy
Group=caddy
ExecStart=/usr/local/bin/caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
ExecReload=/usr/local/bin/caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile
WorkingDirectory=/etc/caddy
Restart=on-failure
TimeoutStopSec=5s
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
```

---

## 7. **Reload systemd and enable/start Caddy**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
sudo systemctl status caddy
```

---

## 8. **Check Caddy logs for errors**

```bash
journalctl -u caddy.service -b --no-pager --lines=30
```

Look out for permission errors or binding issues.

---

## 9. **Optional: Fix CA certificate trust warnings**

Install certutil to allow Caddy to add its root cert to local stores:

```bash
sudo apt update
sudo apt install libnss3-tools
sudo systemctl restart caddy
```

---

## 10. **Test HTTPS access**

On your LAN devices, open:

```
https://192.168.68.102
```

You should see the code-server interface served securely by Caddy.

---

# Troubleshooting Summary

| Problem                                     | Solution                                                            |
| ------------------------------------------- | ------------------------------------------------------------------- |
| `Service caddy.service does not exist`      | Create proper systemd service file, reload daemon                   |
| `Permission denied binding to ports 80/443` | Run `sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy`   |
| `Caddy TLS verify error with backend`       | Use `tls_insecure_skip_verify` inside `transport http` in Caddyfile |
| `Failed to register ServiceWorker`          | Use Caddy HTTPS proxy properly to avoid mixed content               |
| `caddy user permission denied on folders`   | Create caddy user and assign ownership to config folders            |
| `Missing certutil`                          | Install `libnss3-tools` for cert management convenience             |

---

If you want, I can also help automate code-server startup or add password authentication on Caddy.

---

Would you like me to generate a ready-to-use shell script for all these steps?
