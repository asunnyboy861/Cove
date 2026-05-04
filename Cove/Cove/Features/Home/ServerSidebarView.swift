import SwiftUI
import SwiftData

struct ServerSidebarView: View {
    @Binding var selectedServer: Server?
    @Query var servers: [Server]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List(servers, selection: $selectedServer) { server in
            ServerIconView(server: server)
                .tag(server)
        }
        .listStyle(.sidebar)
        .navigationTitle("Cove")
        .overlay(alignment: .bottom) {
            Button {
                addSampleServer()
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(Color.coveTeal.opacity(0.2))
                    .foregroundStyle(.coveTeal)
                    .clipShape(Circle())
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            if servers.isEmpty {
                addSampleServer()
            }
        }
    }

    private func addSampleServer() {
        let server = Server(name: "Cove Community", isOwner: false)
        server.memberCount = 42

        let general = Category(name: "General")
        let voice = Category(name: "Voice Channels")

        let welcome = Channel(name: "welcome", channelType: "text", topic: "Say hello!")
        let chat = Channel(name: "general", channelType: "text", topic: "General discussion")
        let help = Channel(name: "help", channelType: "text", topic: "Get help here")

        let lounge = Channel(name: "Lounge", channelType: "voice")
        let gaming = Channel(name: "Gaming", channelType: "voice")
        let music = Channel(name: "Music", channelType: "voice")

        general.channels = [welcome, chat, help]
        voice.channels = [lounge, gaming, music]
        server.categories = [general, voice]

        modelContext.insert(server)
        selectedServer = server
    }
}

struct ServerIconView: View {
    let server: Server
    @State private var showInitials = true

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.coveTeal.gradient)
                    .frame(width: 40, height: 40)
                Text(String(server.name.prefix(1)).uppercased())
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(server.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.coveTextPrimary)
                Text("\(server.memberCount) members")
                    .font(.caption)
                    .foregroundStyle(.coveTextSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}
