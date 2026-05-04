import SwiftUI
import SwiftData

struct ChatView: View {
    let channel: Channel
    @Query(filter: #Predicate<Message> { $0.channelId == "" }, sort: \Message.timestamp)
    private var allMessages: [Message]
    @Environment(\.modelContext) private var modelContext
    @State private var messageText = ""
    @State private var filteredMessages: [Message] = []

    var body: some View {
        VStack(spacing: 0) {
            channelHeader
            messageList
            messageInput
        }
        .background(Color.coveBackground)
        .onAppear {
            loadMessages()
        }
    }

    private var channelHeader: some View {
        HStack {
            Image(systemName: "number")
                .foregroundStyle(.coveTextSecondary)
            Text(channel.name)
                .font(.headline)
                .foregroundStyle(.coveTextPrimary)
            if let topic = channel.topic, !topic.isEmpty {
                Text(topic)
                    .font(.caption)
                    .foregroundStyle(.coveTextSecondary)
                    .lineLimit(1)
                Divider()
                    .frame(height: 16)
            }
            Spacer()
            Button {
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.coveTextSecondary)
            }
            Button {
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.coveTextSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.coveSurface1)
        .overlay(alignment: .bottom) { Divider() }
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    if filteredMessages.isEmpty {
                        ContentUnavailableView("No messages yet", systemImage: "text.bubble", description: Text("Start the conversation in #\(channel.name)"))
                            .padding(.top, 60)
                    }
                    ForEach(filteredMessages) { message in
                        MessageRow(message: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .onChange(of: filteredMessages.count) {
                if let last = filteredMessages.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var messageInput: some View {
        HStack(spacing: 12) {
            Button {
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.coveTextSecondary)
            }

            TextField("Message #\(channel.name)", text: $messageText, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(1...5)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.coveSurface2)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(messageText.trimmingCharacters(in: .whitespaces).isEmpty ? .coveTextSecondary : .coveTeal)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.coveSurface1)
        .overlay(alignment: .top) { Divider() }
    }

    private func loadMessages() {
        filteredMessages = allMessages.filter { $0.channelId == channel.id }
    }

    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        let message = Message(
            content: text,
            senderId: "current_user",
            senderName: "You",
            channelId: channel.id
        )
        modelContext.insert(message)
        filteredMessages.append(message)
        messageText = ""
    }
}

struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.coveTeal.gradient)
                .frame(width: 36, height: 36)
                .overlay {
                    Text(String(message.senderName.prefix(1)).uppercased())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(message.senderName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.coveTextPrimary)
                    Text(message.timestamp.messageTime)
                        .font(.caption2)
                        .foregroundStyle(.coveTextSecondary)
                    if message.isEncrypted {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                            .foregroundStyle(.coveSuccess)
                    }
                }
                Text(message.content)
                    .font(.subheadline)
                    .foregroundStyle(.coveTextPrimary)
            }
        }
    }
}
