# Cove - iOS Development Guide

## Executive Summary

Cove is a privacy-first voice rooms and chat app targeting the 200M+ users migrating away from Discord due to mandatory facial scan/government ID verification and data breaches. Cove is the ONLY platform combining Discord-grade voice rooms, Signal-level E2E encryption, zero data collection, and a native iOS experience.

**Product Vision**: A safe harbor for private communication — where users can join voice rooms instantly, chat with E2E encryption, and never worry about their data being collected or leaked.

**Target Audience**: US-based Discord refugees (gamers, creators, communities), privacy-conscious users, and anyone who values secure group voice chat.

**Key Differentiators**:
- Jump-in/jump-out voice rooms with live presence (see who's online before joining)
- Signal Protocol E2E encryption for all direct messages
- Zero data collection — no facial scans, no government IDs, ever
- Native SwiftUI iOS app (not a web wrapper)
- Privacy Dashboard with full data transparency

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Discord | Best voice rooms, huge user base, rich bot ecosystem | Forced ID verification, 70K ID data breach, no E2EE, heavy data collection | Zero data collection + E2EE + no forced verification |
| Element (Matrix) | Decentralized, E2EE, open source | Voice = Jitsi call (can't see who's online), poor mobile UX, notifications broken | Native iOS + real voice rooms + reliable push notifications |
| Stoat | Privacy-focused, growing community | iOS crashes under load, no E2EE, very small team | Stable native iOS + Signal Protocol encryption |
| Guilded | Free, good for gamers, built-in tools | Owned by Roblox (privacy concerns), no E2EE, not privacy-focused | Privacy-first + E2EE + zero tracking |
| Telegram | Fast, cross-platform, large user base | No E2EE by default, group chats not encrypted, metadata collected | E2EE by default for DMs, zero metadata collection |

## Apple Design Guidelines Compliance

- **Clarity**: Clean channel layout with clear visual hierarchy; voice rooms show participant presence at a glance
- **Deference**: Content-first design — messages take center stage, controls are minimal and contextual
- **Depth**: Layered surfaces for dark mode (background → surface1 → surface2 → surface3); voice room participant cards with subtle shadows
- **Consistency**: Standard iOS navigation patterns (TabView, NavigationSplitView); native SF Symbols throughout
- **Accessibility**: VoiceOver support for all interactive elements; Dynamic Type scaling; high contrast color variants
- **Privacy**: App Tracking Transparency prompt on first launch; Privacy Dashboard accessible from Settings; no data collection beyond what's strictly necessary

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), AVFoundation (audio processing)
- **Data**: SwiftData (iOS 17+), local-first with offline support
- **Networking**: async/await + URLSession (WebSocket for real-time messaging)
- **Voice**: LiveKit Swift SDK (Apache 2.0) — SFU architecture for scalable voice rooms
- **Encryption**: CryptoKit + custom Signal Protocol implementation (X3DH + Double Ratchet)
- **Notifications**: APNs via backend push gateway
- **Third-party Dependencies**: LiveKit Swift SDK only (Apache 2.0, commercial-friendly)

## Module Structure

```
Cove/
├── CoveApp.swift
├── Core/
│   ├── Chat/
│   │   ├── ChatService.swift
│   │   ├── MessageStore.swift
│   │   └── ChannelManager.swift
│   ├── Voice/
│   │   ├── LiveKitService.swift
│   │   ├── VoiceRoomManager.swift
│   │   └── AudioProcessor.swift
│   ├── Crypto/
│   │   ├── SignalProtocol.swift
│   │   ├── KeyStore.swift
│   │   └── SessionCipher.swift
│   └── Network/
│       ├── APIClient.swift
│       ├── WebSocketManager.swift
│       └── PushNotificationService.swift
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── ServerListView.swift
│   │   └── ChannelListView.swift
│   ├── Chat/
│   │   ├── ChatView.swift
│   │   ├── MessageListView.swift
│   │   └── MessageInputView.swift
│   ├── Voice/
│   │   ├── VoiceRoomView.swift
│   │   ├── VoiceChannelBar.swift
│   │   └── ParticipantView.swift
│   ├── DM/
│   │   ├── DMListView.swift
│   │   └── DMChatView.swift
│   ├── Settings/
│   │   ├── PrivacyDashboard.swift
│   │   ├── EncryptionSettings.swift
│   │   └── NotificationSettings.swift
│   └── Onboarding/
│       ├── WelcomeView.swift
│       └── RegistrationView.swift
├── Models/
│   ├── Server.swift
│   ├── Channel.swift
│   ├── Message.swift
│   ├── User.swift
│   └── VoiceRoom.swift
├── Services/
│   ├── PurchaseManager.swift
│   └── ContactSupportService.swift
├── Resources/
│   ├── Assets.xcassets
│   └── Localizable.strings
└── Extensions/
    ├── Color+Cove.swift
    ├── View+Modifiers.swift
    └── Date+Formatting.swift
```

## Implementation Flow

1. **Project Setup**: Configure Xcode project with bundle ID `com.zzoutuo.Cove`, iOS 17.0 minimum, SwiftUI lifecycle
2. **Data Models**: Define SwiftData models for Server, Channel, Message, User, VoiceRoom
3. **Color System & Theme**: Implement Cove color palette (Teal #0D9488 brand color, dark mode surfaces)
4. **Navigation Structure**: Build main NavigationSplitView layout (server sidebar → channel list → content)
5. **Onboarding Flow**: Welcome screen → registration (email/anonymous) → profile setup → join community
6. **Chat Core**: WebSocket connection, message send/receive, channel management, @mentions, reactions
7. **Voice Rooms**: LiveKit integration, join/leave rooms, participant grid, speaker detection, mute controls
8. **E2E Encryption**: Signal Protocol key generation, X3DH key exchange, Double Ratchet message encryption for DMs
9. **Privacy Dashboard**: Encryption status display, data collection transparency, data export/delete actions
10. **Push Notifications**: APNs registration, notification handling, background voice mode
11. **IAP & Paywall**: StoreKit 2 subscription management (Free/Plus/Pro tiers)
12. **Settings & Support**: Privacy settings, notification preferences, contact support, policy page links
13. **iPad Adaptation**: Responsive layout for iPad, sidebar optimization
14. **Testing & Polish**: iPhone + iPad simulator testing, accessibility audit, performance optimization

## UI/UX Design Specifications

### Color Scheme

| Role | Light Mode | Dark Mode |
|------|-----------|-----------|
| Brand / Accent | #0D9488 (Cove Teal) | #0D9488 (Cove Teal) |
| Background | #FFFFFF | #0F0F0F |
| Surface 1 | #F9FAFB | #1A1A1A |
| Surface 2 | #F3F4F6 | #252525 |
| Surface 3 | #E5E7EB | #303030 |
| Text Primary | #111827 | #F5F5F5 |
| Text Secondary | #6B7280 | #9CA3AF |
| Success / Safe | #10B981 | #10B981 |
| Warning | #F59E0B | #F59E0B |
| Danger | #EF4444 | #EF4444 |
| Voice Active | #0D9488 | #0D9488 |
| Muted / Offline | #6B7280 | #6B7280 |

### Typography

- **Large Title**: SF Pro Display, 34pt, Bold — Welcome screen, section headers
- **Title 2**: SF Pro Display, 22pt, Bold — Navigation titles
- **Title 3**: SF Pro Display, 20pt, Semibold — Channel names, section headers
- **Headline**: SF Pro Text, 17pt, Semibold — User names, feature labels
- **Body**: SF Pro Text, 17pt, Regular — Message text, descriptions
- **Callout**: SF Pro Text, 16pt, Regular — Channel descriptions
- **Subheadline**: SF Pro Text, 15pt, Regular — Timestamps, secondary info
- **Footnote**: SF Pro Text, 13pt, Regular — Encryption status, metadata
- **Caption**: SF Pro Text, 12pt, Regular — Online counts, badges

### Layout Rules

- **iPhone**: NavigationSplitView with collapsible sidebar; bottom TabBar (Home, Chat, Voice, Notifications, Profile)
- **iPad**: Three-column NavigationSplitView; content area max-width 720pt centered
- **Server Sidebar**: 72pt width, circular server icons (48x48), 4px corner radius
- **Channel List**: 260pt width, sectioned by category, voice channels show green presence dots
- **Voice Room Bar**: Fixed bottom overlay when in voice channel, 56pt height
- **Message Input**: Pinned to bottom with attachment/emoji buttons, auto-expanding text field
- **Voice Room Grid**: 2-column participant grid, speaking participants get teal glow border

### Animations

| Interaction | Animation | Duration |
|-------------|-----------|----------|
| Join voice room | Avatar flies from list into room grid | 300ms spring |
| Speaking indicator | Border glow pulse synced with volume | Continuous |
| Message send | Slides from input into message list | 200ms ease-out |
| Encryption verify | Shield icon flip confirmation | 400ms spring |
| Server switch | Sidebar slide + content crossfade | 250ms ease-in-out |

## Code Generation Rules

- Architecture: MVVM pattern — View renders UI, ViewModel handles business logic
- State Management: @Observable (iOS 17+) + Combine for reactive updates
- Networking: async/await + URLSession, no third-party HTTP libraries
- Database: SwiftData (iOS 17+), local-first, offline-capable
- Encryption: CryptoKit + custom Signal Protocol, no third-party crypto libraries
- Voice: LiveKit Swift SDK (Apache 2.0), only third-party dependency
- UI: Pure SwiftUI, iOS 17.0 minimum target
- No code comments unless explicitly requested
- All model attributes must be optional or have default values
- iPad content areas must use `.frame(maxWidth: 720).frame(maxWidth: .infinity)` in ScrollViews
- Never use `.tabViewStyle(.sidebarAdaptable)` — use standard TabView

## Build & Deployment Checklist

- [ ] Xcode project configured with bundle ID `com.zzoutuo.Cove`
- [ ] iOS Deployment Target set to 17.0
- [ ] App Icon generated and added to Asset Catalog
- [ ] Capabilities configured: Push Notifications, Background Modes (Audio, VoIP)
- [ ] StoreKit 2 subscription products configured
- [ ] Policy pages deployed to GitHub Pages
- [ ] Build succeeds on iPhone simulator (iPhone XS Max)
- [ ] Build succeeds on iPad simulator (iPad Pro 13-inch M4)
- [ ] App launches and core features work on both simulators
- [ ] No hardcoded secrets in source code
- [ ] App Store metadata prepared (keytext.md)
- [ ] Screenshots captured for iPhone 6.7" and iPad Pro 12.9"
