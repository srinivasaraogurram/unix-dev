#!/bin/bash

set -e

### Configurable variables
CADDY_VERSION="2.7.6"
LAN_IP="192.168.68.102"  # <-- Change this to your actual Odroid IP if different
CODE_SERVER_PORT="3000"
CADDY_BIN="/usr/local/bin/caddy"
CADDY_USER="caddy"

echo "==> Downloading and installing Caddy..."
curl -LO "https://github.com/caddyserver/caddy/releases/download/v$CADDY_VERSION/caddy_${CADDY_VERSION}_linux_arm64.tar.gz"
tar -xzf "caddy_${CADDY_VERSION}_linux_arm64.tar.gz"
sudo install caddy "$CADDY_BIN"

echo "==> Creating system user and folders..."
sudo useradd --system --home /var/lib/caddy --shell /usr/sbin/nologin $CADDY_USER || true
sudo mkdir -p /etc/caddy /var/lib/caddy /var/log/caddy
sudo chown -R $CADDY_USER:$CADDY_USER /etc/caddy /var/lib/caddy /var/log/caddy

echo "==> Creating Caddyfile..."
sudo tee /etc/caddy/Caddyfile > /dev/null <<EOF
$LAN_IP:443 {
    reverse_proxy https://localhost:$CODE_SERVER_PORT {
        transport http {
            tls_insecure_skip_verify
        }
    }
    tls internal
}
EOF

echo "==> Granting permission to bind port 443..."
sudo setcap 'cap_net_bind_service=+ep' "$CADDY_BIN"

echo "==> Creating systemd service..."
sudo tee /etc/systemd/system/caddy.service > /dev/null <<EOF
[Unit]
Description=Caddy Web Server
After=network.target

[Service]
User=$CADDY_USER
Group=$CADDY_USER
ExecStart=$CADDY_BIN run --config /etc/caddy/Caddyfile --adapter caddyfile
ExecReload=$CADDY_BIN reload --config /etc/caddy/Caddyfile --adapter caddyfile
WorkingDirectory=/etc/caddy
Restart=on-failure
TimeoutStopSec=5s
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

echo "==> Enabling and starting Caddy..."
sudo systemctl daemon-reload
sudo systemctl enable --now caddy

echo "✅ Caddy is now running and reverse proxying https://$LAN_IP to your code-server."
