import SwiftUI

struct VoiceRoomView: View {
    let channel: Channel
    @State private var isMuted = true
    @State private var isDeafened = false
    @State private var isConnected = false
    @State private var participants: [VoiceParticipant] = []

    var body: some View {
        VStack(spacing: 0) {
            voiceHeader
            participantGrid
            listenerSection
            Spacer()
            controlBar
        }
        .background(Color.coveBackground)
    }

    private var voiceHeader: some View {
        HStack {
            Image(systemName: "speaker.wave.2.fill")
                .foregroundStyle(.coveTeal)
            Text(channel.name)
                .font(.headline)
                .foregroundStyle(.coveTextPrimary)
            Spacer()
            Text("\(participants.count) in room")
                .font(.caption)
                .foregroundStyle(.coveTextSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.coveSurface1)
        .overlay(alignment: .bottom) { Divider() }
    }

    private var participantGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(participants) { participant in
                    ParticipantCard(participant: participant)
                }
                if !isConnected {
                    joinCard
                }
            }
            .padding(16)
        }
    }

    private var joinCard: some View {
        VStack(spacing: 8) {
            Circle()
                .strokeBorder(Color.coveTeal, style: StrokeStyle(lineWidth: 2, dash: [6]))
                .frame(width: 64, height: 64)
                .overlay {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.coveTeal)
                }
            Text("Join")
                .font(.caption)
                .foregroundStyle(.coveTeal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.coveSurface1)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            joinRoom()
        }
    }

    private var listenerSection: some View {
        Group {
            if participants.filter({ !$0.isSpeaking }).count > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Listeners")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.coveTextSecondary)
                    HStack(spacing: -8) {
                        ForEach(participants.filter { !$0.isSpeaking }.prefix(5)) { _ in
                            Circle()
                                .fill(Color.coveSurface3)
                                .frame(width: 28, height: 28)
                                .overlay(Circle().stroke(Color.coveBackground, lineWidth: 2))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var controlBar: some View {
        HStack(spacing: 0) {
            Spacer()
            controlButton(icon: isMuted ? "mic.slash.fill" : "mic.fill", label: isMuted ? "Unmute" : "Mute", color: isMuted ? .coveDanger : .coveTeal) {
                isMuted.toggle()
            }
            Spacer()
            controlButton(icon: "phone.down.fill", label: "Leave", color: .coveDanger) {
                leaveRoom()
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .background(Color.coveSurface1)
        .overlay(alignment: .top) { Divider() }
    }

    private func controlButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundStyle(color)
                    }
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.coveTextSecondary)
            }
        }
    }

    private func joinRoom() {
        isConnected = true
        participants = [
            VoiceParticipant(name: "You", isSpeaking: !isMuted, isMuted: isMuted),
            VoiceParticipant(name: "Alex", isSpeaking: true, isMuted: false),
            VoiceParticipant(name: "Sam", isSpeaking: false, isMuted: true)
        ]
    }

    private func leaveRoom() {
        isConnected = false
        participants = []
    }
}

struct VoiceParticipant: Identifiable {
    let id = UUID()
    let name: String
    let isSpeaking: Bool
    let isMuted: Bool
}

struct ParticipantCard: View {
    let participant: VoiceParticipant

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.coveSurface2)
                    .frame(width: 64, height: 64)
                    .overlay {
                        Text(String(participant.name.prefix(1)).uppercased())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.coveTeal)
                    }
                if participant.isSpeaking {
                    Circle()
                        .strokeBorder(Color.coveTeal, lineWidth: 3)
                        .frame(width: 68, height: 68)
                }
                if participant.isMuted {
                    Circle()
                        .fill(Color.coveMuted.opacity(0.8))
                        .frame(width: 20, height: 20)
                        .overlay {
                            Image(systemName: "mic.slash.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 22, y: 22)
                }
            }
            Text(participant.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.coveTextPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.coveSurface1)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
