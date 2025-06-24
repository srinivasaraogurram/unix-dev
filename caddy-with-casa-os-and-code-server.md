Great! Since CasaOS usually runs on **port 80**, and you already have **Caddy** reverse proxying on port 443 for `code-server`, you can integrate CasaOS into your setup without port conflicts by using Caddy's **path-based or subdomain-based routing**.

---

## ✅ Goal: Access both services via Caddy on port 443

| Service     | Local Port | Caddy Path or Subdomain                                               | TLS |
| ----------- | ---------- | --------------------------------------------------------------------- | --- |
| code-server | 3000       | `https://192.168.68.102/`                                             | ✅   |
| CasaOS      | 80         | `https://192.168.68.102/casa` or `https://casa.192.168.68.102.nip.io` | ✅   |

---

## Option 1: Path-Based Routing (easier for LAN)

Update your `/etc/caddy/Caddyfile` to route `/casa` to CasaOS and `/` to code-server:

### 📁 **Updated `/etc/caddy/Caddyfile`**

```caddyfile
192.168.68.102:443 {

    # Route to code-server (default route)
    handle_path / {
        reverse_proxy https://localhost:3000 {
            transport http {
                tls_insecure_skip_verify
            }
        }
    }

    # Route to CasaOS
    handle_path /casa/* {
        reverse_proxy http://localhost:80
    }

    tls internal
}
```

> 🔁 `handle_path` strips the prefix (`/` or `/casa`) from the forwarded request so the backend sees the correct path.

---

### 🧪 Access:

* **code-server:** `https://192.168.68.102/`
* **CasaOS:** `https://192.168.68.102/casa/`

---

## Option 2: Subdomain Routing (requires DNS support)

If you're okay with using something like [`nip.io`](https://nip.io), update your Caddyfile like this:

```caddyfile
192.168.68.102.nip.io:443 {
    reverse_proxy https://localhost:3000 {
        transport http {
            tls_insecure_skip_verify
        }
    }
    tls internal
}

casa.192.168.68.102.nip.io:443 {
    reverse_proxy http://localhost:80
    tls internal
}
```

Then access:

* code-server: `https://192.168.68.102.nip.io`
* CasaOS: `https://casa.192.168.68.102.nip.io`

---

## ✅ After Editing the Caddyfile

Run:

```bash
sudo caddy fmt --overwrite /etc/caddy/Caddyfile
sudo systemctl reload caddy
```

Check status:

```bash
sudo systemctl status caddy
```

---

## 🛠 Troubleshooting Tips

* Make sure CasaOS is running (you can check with `curl http://localhost`).
* If using paths, CasaOS must **not assume it runs at `/`**. If it breaks under `/casa`, use subdomain routing instead.
* Avoid using port 80 directly if Caddy is trying to bind it. Caddy already handles TLS and can forward requests to CasaOS internally.

---

Would you like a script that automatically integrates this with your existing setup?
