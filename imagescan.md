from pathlib import Path

# Define the markdown content
markdown_content = """\
# 🐳 Docker Image Scanning with Snyk — GitHub Actions Documentation

This documentation outlines how to **build**, **scan**, and **report vulnerabilities** for Docker images using **Snyk** within a GitHub Actions workflow.

---

## 🔧 Prerequisites

Ensure the following secrets are added to your GitHub repository:

- `SNYK_TOKEN`: Your Snyk API token (get it from [Snyk account settings](https://app.snyk.io/account)).

Install Docker on the GitHub runner (`ubuntu-latest` includes it by default).

---

## 🧱 Step-by-Step Workflow Overview

### 1. **Build Docker Image**

```yaml
- name: Build Docker image
  run: docker build -t my-image:latest .
