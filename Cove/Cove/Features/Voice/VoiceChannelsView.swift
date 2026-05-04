import SwiftUI

struct VoiceChannelsView: View {
    var body: some View {
        List {
            Section("Active Voice Channels") {
                VoiceChannelRow(name: "Lounge", participants: 3, isActive: true)
                VoiceChannelRow(name: "Gaming", participants: 7, isActive: true)
            }
            Section("Available") {
                VoiceChannelRow(name: "Music", participants: 0, isActive: false)
                VoiceChannelRow(name: "Study Room", participants: 0, isActive: false)
            }
        }
        .navigationTitle("Voice Channels")
        .tint(.coveTeal)
    }
}

struct VoiceChannelRow: View {
    let name: String
    let participants: Int
    let isActive: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "speaker.wave.2.fill")
                .foregroundStyle(isActive ? .coveTeal : .coveTextSecondary)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.coveTextPrimary)
                if participants > 0 {
                    Text("\(participants) listening")
                        .font(.caption)
                        .foregroundStyle(.coveTeal)
                } else {
                    Text("Empty")
                        .font(.caption)
                        .foregroundStyle(.coveTextSecondary)
                }
            }

            Spacer()

            if isActive {
                HStack(spacing: -6) {
                    ForEach(0..<min(participants, 3), id: \.self) { _ in
                        Circle()
                            .fill(Color.coveTeal.gradient)
                            .frame(width: 24, height: 24)
                            .overlay(Circle().stroke(Color.coveBackground, lineWidth: 2))
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
