# 📦 Software Composition Analysis (SCA) Workflow

> Automate open source security scans, generate SBOMs, and detect vulnerabilities using **Snyk** and **Bomber**.

---

## 🔍 What is This?

This GitHub Actions workflow automates **Software Composition Analysis (SCA)** and **SBOM generation** in your CI/CD pipeline. It:

- Scans all projects using [Snyk](https://snyk.io)
- Generates a [CycloneDX](https://cyclonedx.org/) SBOM
- Tests the SBOM with both:
  - `snyk sbom test` (experimental)
  - `bomber scan` using Snyk as the provider
- Uploads artifacts including JSON and HTML reports for auditing

---

## 🚀 Features

✅ Multi-project scanning  
✅ CycloneDX 1.4 SBOM generation  
✅ HTML and JSON reports  
✅ Bomber integration  
✅ SBOM testing with Snyk  
✅ Easy GitHub Actions integration  

---

## ⚙️ Setup Instructions

### 1. Create GitHub Secret

Go to your repository → **Settings → Secrets and Variables → Actions**  
Add a secret called:  
`SNYK_TOKEN = <your_snyk_api_token>`

### 2. Use the Workflow File

Place the following in `.github/workflows/sca.yml` in your repo:

```yaml
name: Software Composition Analysis (SCA)

on:
  push:
    branches:
      - main
      - master
      - snyk
  pull_request:
  workflow_dispatch:

permissions:
  contents: read

jobs:
  sca:
    name: Snyk SCA Scan and SBOM
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🧪 Run Snyk Test on All Projects
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: test --all-projects --json-file-output=snyk.json

      - name: 🧾 Convert Snyk JSON to HTML
        run: |
          npm install -g snyk-to-html
          snyk-to-html -i snyk.json -o snyk-report.html

      - name: 📄 Generate SBOM in CycloneDX Format
        run: |
          npm install -g snyk
          snyk sbom --format=cyclonedx1.4+json --json-file-output=mysbom.json

      - name: 🧪 Snyk SBOM Test (Experimental)
        run: snyk sbom test --file=mysbom.json --experimental
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

      - name: 🧨 Install and Run Bomber on SBOM
        run: |
          curl -Lo bomber https://github.com/devops-kung-fu/bomber/releases/latest/download/bomber-linux-amd64
          chmod +x bomber
          ./bomber scan --provider snyk --token $SNYK_TOKEN mysbom.json --output bomber-report.json

      - name: 📤 Upload Reports as Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: snyk-html-report
          path: snyk-report.html

      - uses: actions/upload-artifact@v4
        with:
          name: snyk-json-report
          path: snyk.json

      - uses: actions/upload-artifact@v4
        with:
          name: sbom-cyclonedx-json
          path: mysbom.json

      - uses: actions/upload-artifact@v4
        with:
          name: bomber-report
          path: bomber-report.json
```

📂 **Workflow Overview**

| Stage           | Tool             | Output Files                    |
| --------------- | ---------------- | ------------------------------- |
| SCA Scan        | `snyk test`      | `snyk.json`, `snyk-report.html` |
| SBOM Generation | `snyk sbom`      | `mysbom.json`                   |
| SBOM Scanning   | `bomber`         | `bomber-report.json`            |
| SBOM Re-Testing | `snyk sbom test` | -                               |

🧪 **CLI Commands Summary**

```sh
# Run a vulnerability scan on all projects
snyk test --all-projects --json-file-output=snyk.json

# Convert Snyk JSON output to HTML
snyk-to-html -i snyk.json -o snyk-report.html

# Generate a CycloneDX SBOM
snyk sbom --format=cyclonedx1.4+json --json-file-output=mysbom.json

# (Experimental) SBOM vulnerability test with Snyk
snyk sbom test --file=mysbom.json --experimental

# Scan SBOM with Bomber and Snyk
bomber scan --provider snyk --token $SNYK_TOKEN mysbom.json --output bomber-report.json
```

📥 **Artifacts Generated**

✅ `snyk-report.html`: Human-readable HTML report  
✅ `snyk.json`: Raw Snyk vulnerability scan  
✅ `mysbom.json`: CycloneDX SBOM file  
✅ `bomber-report.json`: Vulnerability report from Bomber

![alt text](image.png)

![alt text](image-1.png)

![alt text](image-2.png)


🧠 **Best Practices**

- Integrate this workflow early in your CI/CD pipeline.  
- Run it on pull requests to block vulnerable code.  
- Automate dependency updates (e.g., with Dependabot).  
- Use Snyk IDE extensions for local feedback.  
- Review SBOM regularly for compliance and risks.

📘 **References**

- [Snyk CLI Documentation](https://docs.snyk.io)
- [CycloneDX Specification](https://cyclonedx.org/)
- [Bomber on GitHub](https://github.com/devops-kung-fu/bomber)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

