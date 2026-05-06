# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | Cove |
| **Git URL** | git@github.com:asunnyboy861/Cove.git |
| **Repo URL** | https://github.com/asunnyboy861/Cove |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/Cove/ | ✅ Active |
| Support | https://asunnyboy861.github.io/Cove/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/Cove/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/Cove/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

```
Cove/
├── Cove/                        # iOS App Source Code
│   ├── Cove.xcodeproj/          # Xcode Project
│   ├── Cove/                    # Swift Source Files
│   │   ├── Extensions/
│   │   ├── Features/
│   │   ├── Models/
│   │   └── Services/
│   └── ...
├── docs/                        # Policy Pages (GitHub Pages source)
│   ├── support.html             # Support Page
│   ├── privacy.html             # Privacy Policy
│   └── terms.html               # Terms of Use (required for subscription)
├── .github/workflows/
│   └── deploy.yml               # GitHub Pages deployment
├── screenshots/                 # App Store Screenshots
│   ├── 01_home.png
│   ├── 02_chat.png
│   ├── 03_voice.png
│   └── 04_settings.png
├── us.md                        # English Development Guide
├── keytext.md                   # App Store Metadata
├── capabilities.md              # Capabilities Configuration
├── icon.md                      # App Icon Details
├── price.md                     # Pricing Configuration
└── nowgit.md                    # This File
```

## Deployment Information

| Component | Method | Status |
|-----------|--------|--------|
| iOS App Source | Git Push to main | ✅ Pushed |
| Policy Pages | GitHub Actions (deploy.yml) | ✅ Deployed |
| GitHub Pages | Enabled from /docs | ✅ Active |

## Monetization Model

**Subscription (IAP)** - Requires 3 policy pages:
- ✅ Support Page (with subscription management FAQ)
- ✅ Privacy Policy
- ✅ Terms of Use (with Apple IAP clauses)

## Subscription Tiers

| Tier | Monthly | Yearly |
|------|---------|--------|
| Cove Plus | $3.99/mo | $34.99/yr |
| Cove Pro | $7.99/mo | $69.99/yr |

**Free Trial**: 7 days for new Plus subscribers
