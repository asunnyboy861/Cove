import SwiftUI
import SwiftData

@main
struct CoveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Server.self, Category.self, Channel.self, Message.self, User.self, VoiceRoom.self])
    }
}
