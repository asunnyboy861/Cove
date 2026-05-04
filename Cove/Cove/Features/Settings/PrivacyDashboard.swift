import SwiftUI

struct PrivacyDashboard: View {
    var body: some View {
        List {
            Section("Encryption Status") {
                EncryptionStatusRow(title: "Direct Messages", isEncrypted: true, protocolName: "Signal Protocol")
                EncryptionStatusRow(title: "Group Messages", isEncrypted: false, protocolName: "Planned")
                EncryptionStatusRow(title: "Voice Channels", isEncrypted: true, protocolName: "SRTP via LiveKit")
            }

            Section("Data Collection") {
                DataRow(label: "Analytics", value: "None", color: .coveSuccess)
                DataRow(label: "Telemetry", value: "None", color: .coveSuccess)
                DataRow(label: "Crash Reports", value: "Opt-in Only", color: .coveWarning)
                DataRow(label: "Identity Verification", value: "Never Required", color: .coveSuccess)
            }

            Section("Your Data") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Messages stored on server")
                        .font(.subheadline)
                        .foregroundStyle(.coveTextPrimary)
                    Text("Encrypted, auto-delete after 30 days")
                        .font(.caption)
                        .foregroundStyle(.coveTextSecondary)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Voice data")
                        .font(.subheadline)
                        .foregroundStyle(.coveTextPrimary)
                    Text("Never stored, P2P only")
                        .font(.caption)
                        .foregroundStyle(.coveTextSecondary)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("IP Address")
                        .font(.subheadline)
                        .foregroundStyle(.coveTextPrimary)
                    Text("Not logged")
                        .font(.caption)
                        .foregroundStyle(.coveTextSecondary)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Device info")
                        .font(.subheadline)
                        .foregroundStyle(.coveTextPrimary)
                    Text("Not collected")
                        .font(.caption)
                        .foregroundStyle(.coveTextSecondary)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Contacts")
                        .font(.subheadline)
                        .foregroundStyle(.coveTextPrimary)
                    Text("Never uploaded")
                        .font(.caption)
                        .foregroundStyle(.coveTextSecondary)
                }
            }

            Section("Actions") {
                Button {
                } label: {
                    Label("Export My Data", systemImage: "square.and.arrow.up")
                }
                Button {
                } label: {
                    Label("Delete All My Data", systemImage: "trash")
                        .foregroundStyle(.coveDanger)
                }
                Button {
                } label: {
                    Label("Verify Encryption Keys", systemImage: "key")
                }
            }
        }
        .navigationTitle("Privacy Dashboard")
        .tint(.coveTeal)
    }
}

struct EncryptionStatusRow: View {
    let title: String
    let isEncrypted: Bool
    let protocolName: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.coveTextPrimary)
            Spacer()
            HStack(spacing: 4) {
                Circle()
                    .fill(isEncrypted ? Color.coveSuccess : Color.coveWarning)
                    .frame(width: 8, height: 8)
                Text(isEncrypted ? "Encrypted" : "Not Encrypted")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isEncrypted ? .coveSuccess : .coveWarning)
            }
        }
    }
}

struct DataRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.coveTextPrimary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
    }
}
