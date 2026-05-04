# Git Repositories

## Main App (iOS Application + Policy Pages)

| Item | Value |
|------|-------|
| **Repository Name** | Cove |
| **Git URL** | git@github.com:asunnyboy861/Cove.git |
| **Repo URL** | https://github.com/asunnyboy861/Cove |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | Enabled (from /docs folder) |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Support | https://asunnyboy861.github.io/Cove/support.html | Pending |
| Privacy Policy | https://asunnyboy861.github.io/Cove/privacy.html | Pending |
| Terms of Use | https://asunnyboy861.github.io/Cove/terms.html | Pending |

## Repository Structure

### Main App Repository
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
├── docs/                        # Policy Pages (GitHub Pages)
│   ├── support.html
│   ├── privacy.html
│   └── terms.html
├── .github/workflows/
│   └── deploy.yml               # GitHub Pages deployment
├── us.md                        # English Development Guide
├── price.md                     # Pricing Configuration
├── capabilities.md              # Capabilities Configuration
├── icon.md                      # App Icon Details
└── nowgit.md                    # This File
```
