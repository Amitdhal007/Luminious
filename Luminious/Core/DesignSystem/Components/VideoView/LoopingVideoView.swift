import AVFoundation
import UIKit

/// A reusable UIView responsible for playing an intro video using AVPlayer.
///
/// Responsibilities:
/// - Encapsulates AVPlayer setup and lifecycle
/// - Supports auto-looping playback
/// - Provides simple API to play/stop videos
///
/// Assumptions:
/// - Video files are bundled inside app resources
/// - Only one video plays at a time per instance
/// - Looping behavior is required for intro screens
final class IntroVideoView: UIView {

    // MARK: - Core Playback

    private let player = AVPlayer()
    private let playerLayer = AVPlayerLayer()

    /// Observer used for looping playback when video ends.
    private var loopObserver: NSObjectProtocol?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayer()
    }

    deinit {
        if let observer = loopObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        player.pause()
        player.replaceCurrentItem(with: nil)
        playerLayer.player = nil
    }

    // MARK: - Setup

    /// Configures AVPlayer, layer, and looping behavior.
    private func setupPlayer() {

        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        loopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] notification in

            guard let self,
                  let item = notification.object as? AVPlayerItem,
                  item == self.player.currentItem else {
                return
            }

            self.player.seek(to: .zero)
            self.player.play()
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    // MARK: - Playback API

    /// Plays an intro video from app bundle.
    ///
    /// - Parameters:
    ///   - fileName: Name of the video file (without extension)
    ///   - fileType: File extension (default: mp4)
    ///   - bundle: Source bundle (default: main bundle)
    ///   - muted: Whether audio should be muted
    ///   - rate: Playback speed
    ///   - autoPlay: Automatically start playback after loading
    func playIntro(
        named fileName: String,
        fileType: String = "mp4",
        in bundle: Bundle = .main,
        muted: Bool = true,
        rate: Float = 1.0,
        autoPlay: Bool = true
    ) {

        guard let url = bundle.url(forResource: fileName, withExtension: fileType) else {
            assertionFailure("Intro video not found: \(fileName).\(fileType)")
            return
        }

        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)

        player.isMuted = muted
        player.rate = rate

        if autoPlay {
            player.play()
        }
    }

    // MARK: - Control

    /// Stops playback and clears current item.
    func stop() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
}
