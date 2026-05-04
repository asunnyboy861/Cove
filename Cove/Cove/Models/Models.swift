import Foundation
import SwiftData

@Model
final class Server {
    var id: String = UUID().uuidString
    var name: String = ""
    var iconURL: String?
    var bannerURL: String?
    var isOwner: Bool = false
    var memberCount: Int = 0
    var joinedAt: Date = Date()
    @Relationship(deleteRule: .cascade, inverse: \Category.server)
    var categories: [Category] = []

    init(name: String, iconURL: String? = nil, isOwner: Bool = false) {
        self.id = UUID().uuidString
        self.name = name
        self.iconURL = iconURL
        self.isOwner = isOwner
        self.memberCount = 1
        self.joinedAt = Date()
    }
}

@Model
final class Category {
    var id: String = UUID().uuidString
    var name: String = ""
    var sortOrder: Int = 0
    var server: Server?
    @Relationship(deleteRule: .cascade, inverse: \Channel.category)
    var channels: [Channel] = []

    init(name: String, sortOrder: Int = 0) {
        self.id = UUID().uuidString
        self.name = name
        self.sortOrder = sortOrder
    }
}

@Model
final class Channel {
    var id: String = UUID().uuidString
    var name: String = ""
    var channelType: String = "text"
    var topic: String?
    var sortOrder: Int = 0
    var category: Category?

    var isVoice: Bool { channelType == "voice" }

    init(name: String, channelType: String = "text", topic: String? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.channelType = channelType
        self.topic = topic
    }
}

@Model
final class Message {
    var id: String = UUID().uuidString
    var content: String = ""
    var senderId: String = ""
    var senderName: String = ""
    var senderAvatarURL: String?
    var channelId: String = ""
    var timestamp: Date = Date()
    var isEncrypted: Bool = false
    var isEdited: Bool = false
    var reactions: [ReactionData] = []

    init(content: String, senderId: String, senderName: String, channelId: String, isEncrypted: Bool = false) {
        self.id = UUID().uuidString
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.channelId = channelId
        self.timestamp = Date()
        self.isEncrypted = isEncrypted
    }
}

struct ReactionData: Codable, Hashable {
    let emoji: String
    let count: Int
    let reactedByUser: Bool
}

@Model
final class User {
    var id: String = UUID().uuidString
    var username: String = ""
    var displayName: String = ""
    var avatarURL: String?
    var isOnline: Bool = false
    var status: String = "online"
    var createdAt: Date = Date()

    init(username: String, displayName: String) {
        self.id = UUID().uuidString
        self.username = username
        self.displayName = displayName
        self.createdAt = Date()
    }
}

@Model
final class VoiceRoom {
    var id: String = UUID().uuidString
    var channelId: String = ""
    var channelName: String = ""
    var participantCount: Int = 0
    var isActive: Bool = false
    var joinedAt: Date?

    init(channelId: String, channelName: String) {
        self.id = UUID().uuidString
        self.channelId = channelId
        self.channelName = channelName
    }
}
