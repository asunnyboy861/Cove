import Foundation
import LiveKit

actor LiveKitService {
    static let shared = LiveKitService()
    
    private var room: Room?
    private let serverURL = "wss://cove-kql9fowp.livekit.cloud"
    
    // TODO: Load from secure config or backend token server
    // For MVP testing, generate token from LiveKit Cloud dashboard
    // Token expires after 15 minutes - regenerate as needed
    private var testToken: String {
        // Replace with your generated token from LiveKit Cloud
        // Go to: https://cloud.livekit.io/projects/p:livekit-cove
        // Use token generator in dashboard
        return "YOUR_GENERATED_TOKEN_HERE"
    }
    
    private init() {}
    
    func join(roomName: String, participantName: String) async throws {
        let roomOptions = RoomOptions(
            adaptiveStream: true,
            dynacast: true,
            defaultAudioPublishOptions: AudioPublishOptions(
                name: "microphone",
                source: .microphone
            )
        )
        
        let room = Room()
        
        room.delegate = self
        
        // For MVP testing, use pre-generated token
        // TODO: Implement backend token server for production
        try await room.connect(
            url: serverURL,
            token: testToken,
            options: roomOptions
        )
        
        self.room = room
        
        print("Connected to room: \(roomName)")
    }
    
    func leave() async {
        await room?.disconnect()
        room = nil
        print("Left room")
    }
    
    func toggleMute() async {
        guard let localParticipant = room?.localParticipant else { return }
        
        let isMuted = localParticipant.isMicrophoneEnabled == false
        try? await localParticipant.setMicrophoneEnabled(!isMuted)
    }
}

extension LiveKitService: RoomDelegate {
    nonisolated func room(_ room: Room, didFailToConnectWithError error: Error) {
        print("Failed to connect: \(error.localizedDescription)")
    }
    
    nonisolated func room(_ room: Room, didDisconnectWithError error: Error?) {
        if let error = error {
            print("Disconnected with error: \(error.localizedDescription)")
        } else {
            print("Disconnected")
        }
    }
    
    nonisolated func room(_ room: Room, didConnect isSilent: Bool) {
        print("Connected to room")
    }
}
