# 🔐 Container Image Hardening Using Alpine Linux

## 📌 1. Definition of Container and Image

### ✅ Container
A **container** is a lightweight, standalone, executable package that includes everything needed to run a piece of software: code, runtime, system tools, libraries, and settings. Containers run consistently across different computing environments using OS-level virtualization.

### ✅ Image
An **image** is a read-only template used to create containers. It contains:
- Base OS layer
- Application code
- Libraries and dependencies
- Configuration files (defined via `Dockerfile`)

---

## 🔐 2. What is Image Hardening?

**Image hardening** is the process of securing container images by minimizing vulnerabilities and reducing the attack surface. This includes:
- Using minimal base images (e.g., Alpine)
- Removing unnecessary tools and services
- Creating non-root users
- Managing secrets securely
- Limiting network and filesystem access
- Enforcing least privilege
- Enabling image signing (Docker Content Trust)

---

## ⚙️ 3. Hardening Techniques & Security Impact

| Category                 | Hardening Technique                     | Security Impact                            |
| ------------------------ | --------------------------------------- | ------------------------------------------ |
| **Base Image**           | Use minimal image (e.g., Alpine)        | Smaller footprint, fewer CVEs              |
| **Packages**             | Install only required packages          | Avoid extra tools that can be exploited    |
|                          | Remove build-time dependencies          | Reduce surface and image size              |
| **User**                 | Use non-root user (UID:GID)             | Prevent privilege escalation               |
| **Layers**               | Minimize Dockerfile layers              | Reduces image complexity                   |
| **COPY**                 | Use `COPY` instead of `ADD`             | Avoid unintentional tar or remote fetching |
| **Filesystem**           | Set `read-only` and minimal permissions | Prevent unwanted changes during runtime    |
| **Secrets**              | Avoid hardcoded secrets                 | Reduce chance of leaks or exposure         |
| **Network**              | Limit outbound connections              | Minimize exfiltration or malicious access  |
| **Services**             | Disable unnecessary daemons or cron     | Reduce potential attack vectors            |
| **Multi-stage build**    | Split build from final runtime          | Keeps only required binaries               |
| **Lifecycle Management** | Tag, scan, archive, retire images       | Avoid stale or vulnerable images           |
| **DCT**                  | Docker Content Trust                    | Enables image signing and verification     |

---

## 🐳 4. Hardened Dockerfile Using Alpine

### 📁 Project Structure
```
hardened-app/
├── Dockerfile
├── app.py
└── requirements.txt
```

### 🔐 Dockerfile

```dockerfile
# ---------- Stage 1: Build ----------
FROM python:3.12-alpine as builder

WORKDIR /app

# Install build dependencies only temporarily
RUN apk add --no-cache build-base libffi-dev

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# ---------- Stage 2: Runtime ----------
FROM python:3.12-alpine

LABEL maintainer="you@example.com"
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appgroup app.py .

# Secure permissions
RUN chmod -R 755 /app

USER appuser
EXPOSE 5000

# Read-only filesystem (add in runtime flags)
VOLUME ["/tmp"]

CMD ["python", "app.py"]
```

### 📦 requirements.txt

```
Flask==3.0.0
```

### ⚙️ app.py

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Secure Hardened Flask App Running!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

## 🧪 5. Run the Hardened App

### 🔨 Build the Image

```bash
docker build -t hardened-flask-app .
```

### 🚀 Run Securely

```bash
docker run --rm \
  --read-only \
  --cap-drop=ALL \
  -p 5000:5000 \
  hardened-flask-app
```

---

## 🆚 6. Alpine vs Ubuntu Comparison

| Feature         | Alpine                               | Ubuntu                                |
| --------------- | ------------------------------------ | ------------------------------------- |
| Size            | ~5MB                                 | ~29MB (slim) or larger                |
| Package Manager | `apk`                                | `apt`                                 |
| libc            | `musl`                               | `glibc`                               |
| Performance     | Fast and lightweight                 | Heavier but more compatible           |
| CVE Exposure    | Very low                             | Moderate                              |
| Use Cases       | Microservices, production-ready apps | Development environments, legacy apps |

---

## 📊 7. Comparative Analysis of Minimal Base Images

| Base        | Size   | Attack Surface | Compatibility    | Use Case                         |
| ----------- | ------ | -------------- | ---------------- | -------------------------------- |
| Alpine      | ~5MB   | Minimal        | Some limitations | Security-focused apps            |
| Ubuntu Slim | ~29MB  | Moderate       | High             | General use                      |
| Debian Slim | ~22MB  | Low            | High             | Stable production                |
| Distroless  | ~10MB  | Minimal        | Limited          | High security, minimal footprint |

---

## 🔐 8. Implementing Docker Content Trust (DCT)

### ✅ What is Docker Content Trust?

Docker Content Trust (DCT) ensures that only signed container images are pulled, providing:
- Image authenticity
- Publisher integrity
- Secure supply chain

### 🔧 Enable DCT

```bash
export DOCKER_CONTENT_TRUST=1
docker pull alpine
```

---

## 🔄 9. Image Lifecycle Management

### ✅ Why?

Unmaintained images can:
- Contain critical CVEs
- Break compliance
- Increase attack vectors

### 🔁 Methodology

- Tagging: Use v1, v2.1, latest, stable
- Scanning: Automate using Trivy, Snyk, or Docker Scout
- Retention: Clean old images via policy
- Signing: Use DCT or Cosign
- Audit Logging: Track changes and usage

---

## ✅ 10. Summary

- Use minimal base images (Alpine, Distroless) to reduce attack surface
- Apply best practices: non-root users, secure permissions, multi-stage builds
- Enable Docker Content Trust for integrity verification
- Perform lifecycle management to avoid stale images
- Hardened images ensure safer deployment pipelines in modern DevOps workflows