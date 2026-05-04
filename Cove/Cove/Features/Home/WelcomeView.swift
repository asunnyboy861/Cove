import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color.coveTeal.gradient)

            Text("Welcome to Cove")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.coveTextPrimary)

            Text("Your private voice & chat haven")
                .font(.title3)
                .foregroundStyle(.coveTextSecondary)

            HStack(spacing: 32) {
                FeatureBadge(icon: "lock.shield.fill", title: "E2E Encrypted")
                FeatureBadge(icon: "mic.fill", title: "Voice Rooms")
                FeatureBadge(icon: "eye.slash.fill", title: "Zero Tracking")
            }
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.coveBackground)
    }
}

struct FeatureBadge: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.coveTeal)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.coveTextSecondary)
        }
        .frame(width: 90)
    }
}
