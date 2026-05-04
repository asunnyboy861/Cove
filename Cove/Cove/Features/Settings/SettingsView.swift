import SwiftUI

struct SettingsView: View {
    @State private var showPrivacyDashboard = false
    @State private var showEncryptionSettings = false
    @State private var showNotificationSettings = false

    var body: some View {
        List {
            Section("Account") {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.coveTeal.gradient)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Text("Y")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("CoveUser")
                            .font(.headline)
                            .foregroundStyle(.coveTextPrimary)
                        Text("coveuser@example.com")
                            .font(.caption)
                            .foregroundStyle(.coveTextSecondary)
                    }
                }
            }

            Section("Subscription") {
                NavigationLink {
                    PaywallView()
                } label: {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.coveWarning)
                        Text("Upgrade to Cove Plus")
                            .foregroundStyle(.coveTextPrimary)
                    }
                }
                Button {
                } label: {
                    HStack {
                        Image(systemName: "arrow.uturn.backward")
                            .foregroundStyle(.coveTeal)
                        Text("Restore Purchases")
                            .foregroundStyle(.coveTextPrimary)
                    }
                }
            }

            Section("Privacy & Security") {
                NavigationLink(isActive: $showPrivacyDashboard) {
                    PrivacyDashboard()
                } label: {
                    Label("Privacy Dashboard", systemImage: "lock.shield.fill")
                }
                NavigationLink(isActive: $showEncryptionSettings) {
                    EncryptionSettings()
                } label: {
                    Label("Encryption Settings", systemImage: "key.fill")
                }
            }

            Section("Notifications") {
                NavigationLink(isActive: $showNotificationSettings) {
                    NotificationSettings()
                } label: {
                    Label("Notification Settings", systemImage: "bell.fill")
                }
            }

            Section("Support") {
                NavigationLink {
                    ContactSupportView()
                } label: {
                    Label("Contact Support", systemImage: "envelope.fill")
                }
                Link(destination: URL(string: "https://asunnyboy861.github.io/Cove/support.html")!) {
                    Label("Support Page", systemImage: "questionmark.circle")
                }
                Link(destination: URL(string: "https://asunnyboy861.github.io/Cove/privacy.html")!) {
                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                }
                Link(destination: URL(string: "https://asunnyboy861.github.io/Cove/terms.html")!) {
                    Label("Terms of Use", systemImage: "doc.text.fill")
                }
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.coveTextSecondary)
                }
                HStack {
                    Text("Build")
                    Spacer()
                    Text("1")
                        .foregroundStyle(.coveTextSecondary)
                }
            }
        }
        .navigationTitle("Settings")
        .tint(.coveTeal)
    }
}
