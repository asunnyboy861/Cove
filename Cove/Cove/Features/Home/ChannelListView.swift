import SwiftUI
import SwiftData

struct ChannelListView: View {
    let selectedServer: Server?
    @Binding var selectedChannel: Channel?
    @Query var voiceRooms: [VoiceRoom]

    var body: some View {
        List {
            if let server = selectedServer {
                ForEach(server.categories.sorted { $0.sortOrder < $1.sortOrder }) { category in
                    Section(category.name) {
                        ForEach(category.channels.sorted { $0.sortOrder < $1.sortOrder }) { channel in
                            ChannelRow(channel: channel, isSelected: selectedChannel?.id == channel.id)
                                .onTapGesture {
                                    selectedChannel = channel
                                }
                        }
                    }
                }
            } else {
                ContentUnavailableView("No Server Selected", systemImage: "server.rack", description: Text("Select a server from the sidebar"))
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(selectedServer?.name ?? "Cove")
    }
}

struct ChannelRow: View {
    let channel: Channel
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: channel.isVoice ? "speaker.wave.2.fill" : "number")
                .font(.caption)
                .foregroundStyle(channel.isVoice ? .coveTeal : .coveTextSecondary)

            Text(channel.name)
                .font(.subheadline)
                .foregroundStyle(isSelected ? .coveTextPrimary : .coveTextSecondary)

            Spacer()

            if channel.isVoice {
                Circle()
                    .fill(Color.coveSuccess)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(isSelected ? Color.coveTeal.opacity(0.1) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
