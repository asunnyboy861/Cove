import Foundation
import LiveKit

actor LiveKitService {
    static let shared = LiveKitService()
    
    private var room: Room?
    private let serverURL = "wss://cove-kql9fowp.livekit.cloud"
    private let apiKey = "APIMHobLy2Nny6k"
    
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
        
        try await room.connect(
            url: serverURL,
            token: try await generateToken(room: roomName, participant: participantName),
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
    
    private func generateToken(room: String, participant: String) async throws -> String {
        let token = AccessToken(apiKey: apiKey, secret: "YOUR_API_SECRET")
            .withIdentity(participant)
            .withName(participant)
            .withRoom(room)
            .withVideoJoin(true)
        
        return try token.toJWT()
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
