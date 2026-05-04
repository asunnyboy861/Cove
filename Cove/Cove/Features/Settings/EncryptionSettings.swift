import SwiftUI

struct EncryptionSettings: View {
    @State private var encryptDMsByDefault = true
    @State private var showEncryptionBadges = true
    @State private var verifySafetyNumbers = false

    var body: some View {
        List {
            Section("Direct Messages") {
                Toggle("Encrypt by Default", isOn: $encryptDMsByDefault)
                Toggle("Show Encryption Badges", isOn: $showEncryptionBadges)
            }

            Section("Key Verification") {
                Toggle("Verify Safety Numbers", isOn: $verifySafetyNumbers)
                Button {
                } label: {
                    Label("View My Public Key", systemImage: "key.fill")
                }
            }

            Section("Advanced") {
                Button {
                } label: {
                    Label("Regenerate PreKeys", systemImage: "arrow.triangle.2.circlepath")
                }
                Button {
                } label: {
                    Label("Reset Session Keys", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.coveDanger)
                }
            }
        }
        .navigationTitle("Encryption")
        .tint(.coveTeal)
    }
}
