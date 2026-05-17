import AVFoundation
import SwiftUI

enum SoundEffect: String, CaseIterable, Hashable {
    case crickets = "crickets"
    case sadTrombone = "sad_trombone"
    case dramaticGasp = "dramatic_gasp"
    case tumbleweed = "tumbleweed"

    var displayName: String {
        switch self {
        case .crickets: return "Crickets"
        case .sadTrombone: return "Sad Trombone"
        case .dramaticGasp: return "Dramatic Gasp"
        case .tumbleweed: return "Tumbleweed"
        }
    }
}

final class AudioManager: NSObject, ObservableObject {
    @Published private(set) var currentSound: SoundEffect?

    private var player: AVAudioPlayer?
    private let startHaptic = UIImpactFeedbackGenerator(style: .rigid)
    private let endHaptic = UIImpactFeedbackGenerator(style: .soft)

    override init() {
        super.init()
        startHaptic.prepare()
        endHaptic.prepare()
        configureAudioSession()
    }

    func play(sound: SoundEffect) {
        stopCurrentSound()

        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
            assertionFailure("Missing sound file: \(sound.rawValue).mp3")
            return
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()

            player = audioPlayer
            currentSound = sound

            startHaptic.impactOccurred(intensity: 1.0)
            startHaptic.prepare()
        } catch {
            print("Audio playback failed: \(error.localizedDescription)")
        }
    }

    func stopCurrentSound() {
        guard let player else { return }

        player.stop()
        self.player = nil
        currentSound = nil

        endHaptic.impactOccurred(intensity: 0.8)
        endHaptic.prepare()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session configuration failed: \(error.localizedDescription)")
        }
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        currentSound = nil

        endHaptic.impactOccurred(intensity: 0.8)
        endHaptic.prepare()
    }
}
