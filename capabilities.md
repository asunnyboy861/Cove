# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- Voice rooms → Background Modes (Audio, VoIP)
- Push notifications → Push Notifications capability
- E2E encryption → No special capability needed (CryptoKit is built-in)
- Contact support → Network client (outgoing connections)
- Subscription IAP → StoreKit (no special capability needed for StoreKit 2)

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Push Notifications | ✅ Configured | Xcode project |
| Background Modes (Audio) | ✅ Configured | Info.plist |
| Background Modes (VoIP) | ✅ Configured | Info.plist |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| Push Notifications (APNs Cert) | ⏳ Pending | Upload APNs certificate to server backend when deploying |
| In-App Purchase (StoreKit 2) | ✅ No capability needed | StoreKit 2 uses ProductID configuration in App Store Connect |

## No Configuration Needed
- iCloud / CloudKit — Not used (local-first storage)
- HealthKit — Not applicable
- Camera / Photo Library — Not in MVP
- Location Services — Not applicable
- Apple Watch — Not in MVP
- Siri — Not in MVP
- Sign in with Apple — Not in MVP (email/anonymous registration)

## Verification
- Build succeeded after configuration: ⏳ Pending
- All entitlements correct: ⏳ Pending
