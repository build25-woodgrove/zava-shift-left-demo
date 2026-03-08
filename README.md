# Shift-Left Security Demo

Intentionally vulnerable application for demonstrating **Microsoft Defender for Cloud** shift-left security features.

> **WARNING**: This repository contains deliberate security vulnerabilities for demo purposes. DO NOT deploy to production.

## Scanner Coverage

| Scanner | Trigger Files | Findings |
|---------|--------------|----------|
| **Trivy** (CVEs) | `requirements.txt`, `package.json`, `Dockerfile` | Vulnerable dependencies + container base image (node:14) |
| **Bandit** (Python) | `src/script.py` | Hardcoded creds, eval, shell injection, SQL injection, weak crypto |
| **ESLint** (JavaScript) | `src/app.js` | eval(), unused vars, loose equality, SQL concat |
| **Checkov / Terrascan** (Terraform) | `main.tf` | Public S3, open SG, unencrypted RDS, public storage |
| **Template Analyzer** (Bicep/ARM) | `insecure.bicep` | No HTTPS, weak TLS, public blob access, no soft-delete |

## Code-to-Runtime (C2C) Mapping

All 3 methods for establishing code-to-runtime relationships are implemented:

| Method | Implementation | How It Works |
|--------|---------------|--------------|
| **Method 1: DevOps Connector** | ZavaGithub connector in MDC | Automatic mapping when repo is connected to Defender for Cloud |
| **Method 2: Docker Labels** | `Dockerfile` + `docker/metadata-action` in pipeline | OCI annotations (`org.opencontainers.image.source`, `.revision`, etc.) embedded in image manifest |
| **Method 3: GitHub Attestations** | `actions/attest-build-provenance` in pipeline | Cryptographic provenance linking image digest to source repo + commit |

### Prerequisites (from C2C Tech Prereq)
- Defender CSPM or Defender for Containers enabled on cloud environment
- Container images built through CI/CD pipeline (this repo)
- Container images discoverable by Defender for Cloud (stored in supported registry: ACR)

## Pipelines

- **MSDO Scan** (`.github/workflows/msdo.yml`) - Runs all Defender CLI scanners, publishes SARIF to MDC
- **Build & Push** (`.github/workflows/build-and-push.yml`) - Builds container with OCI labels + attestation, pushes to ACR

## Setup

1. Connect this repo to Microsoft Defender for Cloud via GitHub connector
2. Configure repo variables and secrets:
   - Variable: `ACR_ENDPOINT` (e.g., `alpinecontainerreg.azurecr.io`)
   - Secret: `REGISTRY_USERNAME`
   - Secret: `REGISTRY_PASSWORD`
3. Push to `main` to trigger both pipelines
4. View results in MDC > Defender for DevOps > Security tab

## Target Registries (Zava-Public Tenant)

| Registry | Endpoint | Type |
|----------|----------|------|
| alpineContainerReg | `alpinecontainerreg.azurecr.io` | Azure ACR |
| acrgated | `acrgated.azurecr.io` | Azure ACR |
| mdc-gcp-artifactregistry | `us-docker.pkg.dev/mdc-demo/mdc-gcp-artifactregistry` | GCP GAR |
