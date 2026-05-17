import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()

    private let sounds: [SoundEffect] = [
        .crickets,
        .sadTrombone,
        .dramaticGasp,
        .tumbleweed
    ]

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("QuietCure")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 12)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(sounds, id: \.self) { sound in
                        GlassSoundButton(
                            title: sound.displayName,
                            isActive: audioManager.currentSound == sound
                        ) {
                            audioManager.play(sound: sound)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 0)
            }

            ProBadgeView()
                .padding(.trailing, 20)
                .padding(.top, 16)
        }
    }
}

private struct GlassSoundButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    private let accent = Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(accent.opacity(isActive ? 0.9 : 0.0), lineWidth: 2)
                    )

                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(12)
            }
            .frame(height: 170)
            .shadow(color: accent.opacity(isActive ? 0.45 : 0.0), radius: 16, y: 4)
        }
        .buttonStyle(.plain)
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct ProBadgeView: View {
    private let accent = Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)

    var body: some View {
        Text("QuietCure Pro License: Active")
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(accent.opacity(0.2))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(accent, lineWidth: 1)
                    )
            )
    }
}

#Preview {
    ContentView()
}
