import SwiftUI

struct NotificationsView: View {
    @State private var notifications: [AppNotification] = []

    var body: some View {
        List {
            Section("Today") {
                ForEach(notifications.filter { $0.isToday }) { notif in
                    NotificationRow(notification: notif)
                }
            }
            Section("Earlier") {
                ForEach(notifications.filter { !$0.isToday }) { notif in
                    NotificationRow(notification: notif)
                }
            }
        }
        .navigationTitle("Notifications")
        .tint(.coveTeal)
        .onAppear {
            if notifications.isEmpty {
                notifications = [
                    AppNotification(title: "New message from Alice", description: "Hey, want to join the voice room?", icon: "message.fill", isToday: true),
                    AppNotification(title: "Voice room active", description: "3 people are in Lounge", icon: "speaker.wave.2.fill", isToday: true),
                    AppNotification(title: "New member joined", description: "Eve joined Cove Community", icon: "person.badge.plus", isToday: false)
                ]
            }
        }
    }
}

struct AppNotification: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let isToday: Bool
}

struct NotificationRow: View {
    let notification: AppNotification

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: notification.icon)
                .font(.title3)
                .foregroundStyle(.coveTeal)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(notification.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.coveTextPrimary)
                Text(notification.description)
                    .font(.caption)
                    .foregroundStyle(.coveTextSecondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
