import Foundation
import LiveKit

actor LiveKitService {
    static let shared = LiveKitService()
    
    private var room: Room?
    private let serverURL = "wss://cove-kql9fowp.livekit.cloud"
    
    // Cloudflare Worker Token Server URL
    // Deployed at: https://cove-token-server.iocompile67692.workers.dev
    private let tokenServerURL = "https://cove-token-server.iocompile67692.workers.dev"
    
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
        
        // Generate token from Cloudflare Worker
        let token = try await generateToken(room: roomName, participant: participantName)
        
        try await room.connect(
            url: serverURL,
            token: token,
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
        let url = URL(string: tokenServerURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "room": room,
            "participant": participant
        ])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        return tokenResponse.token
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

struct TokenResponse: Codable {
    let token: String
}
