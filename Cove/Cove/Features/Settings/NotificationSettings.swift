import SwiftUI

struct NotificationSettings: View {
    @State private var pushNotifications = true
    @State private var messageNotifications = true
    @State private var voiceChannelNotifications = true
    @State private var communityUpdates = false
    @State private var soundEnabled = true
    @State private var vibrationEnabled = true

    var body: some View {
        List {
            Section("Push Notifications") {
                Toggle("Enable Push Notifications", isOn: $pushNotifications)
            }

            Section("Notification Types") {
                Toggle("Direct Messages", isOn: $messageNotifications)
                Toggle("Voice Channel Activity", isOn: $voiceChannelNotifications)
                Toggle("Community Updates", isOn: $communityUpdates)
            }

            Section("Sound & Haptics") {
                Toggle("Notification Sound", isOn: $soundEnabled)
                Toggle("Vibration", isOn: $vibrationEnabled)
            }

            Section("Quiet Hours") {
                NavigationLink {
                    Text("Quiet Hours Configuration")
                } label: {
                    Label("Quiet Hours", systemImage: "moon.fill")
                }
            }
        }
        .navigationTitle("Notifications")
        .tint(.coveTeal)
    }
}
