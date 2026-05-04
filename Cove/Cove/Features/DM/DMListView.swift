import SwiftUI

struct DMListView: View {
    @State private var conversations: [DMConversation] = []

    var body: some View {
        List {
            Section("Direct Messages") {
                ForEach(conversations) { conv in
                    DMRow(conversation: conv)
                }
            }
        }
        .navigationTitle("Messages")
        .tint(.coveTeal)
        .onAppear {
            if conversations.isEmpty {
                conversations = [
                    DMConversation(name: "Alice", lastMessage: "Hey, want to join the voice room?", time: "2m", isOnline: true, isEncrypted: true),
                    DMConversation(name: "Bob", lastMessage: "Thanks for the invite!", time: "15m", isOnline: true, isEncrypted: true),
                    DMConversation(name: "Carol", lastMessage: "See you later", time: "1h", isOnline: false, isEncrypted: true),
                    DMConversation(name: "Dave", lastMessage: "The new update is great", time: "3h", isOnline: false, isEncrypted: false)
                ]
            }
        }
    }
}

struct DMConversation: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let time: String
    let isOnline: Bool
    let isEncrypted: Bool
}

struct DMRow: View {
    let conversation: DMConversation

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.coveSurface3)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Text(String(conversation.name.prefix(1)).uppercased())
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.coveTeal)
                    }
                Circle()
                    .fill(conversation.isOnline ? Color.coveSuccess : Color.coveMuted)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Color.coveBackground, lineWidth: 2))
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text(conversation.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.coveTextPrimary)
                    if conversation.isEncrypted {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                            .foregroundStyle(.coveSuccess)
                    }
                }
                Text(conversation.lastMessage)
                    .font(.caption)
                    .foregroundStyle(.coveTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(conversation.time)
                .font(.caption2)
                .foregroundStyle(.coveTextSecondary)
        }
        .padding(.vertical, 4)
    }
}
