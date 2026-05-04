import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedServer: Server?
    @State private var selectedChannel: Channel?

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationSplitView {
                ServerSidebarView(selectedServer: $selectedServer)
            } content: {
                ChannelListView(selectedServer: selectedServer, selectedChannel: $selectedChannel)
            } detail: {
                if let channel = selectedChannel {
                    if channel.isVoice {
                        VoiceRoomView(channel: channel)
                    } else {
                        ChatView(channel: channel)
                    }
                } else {
                    WelcomeView()
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                DMListView()
            }
            .tabItem {
                Label("Messages", systemImage: "message.fill")
            }
            .tag(1)

            NavigationStack {
                VoiceChannelsView()
            }
            .tabItem {
                Label("Voice", systemImage: "mic.fill")
            }
            .tag(2)

            NavigationStack {
                NotificationsView()
            }
            .tabItem {
                Label("Alerts", systemImage: "bell.fill")
            }
            .tag(3)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle.fill")
            }
            .tag(4)
        }
        .tint(.coveTeal)
    }
}
