import AVFoundation
import UIKit

final class IntroVideoView: UIView {

    private let player = AVPlayer()
    private let playerLayer = AVPlayerLayer()

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
        if let loopObserver = loopObserver {
            NotificationCenter.default.removeObserver(loopObserver)
        }
    }

    // MARK: - Setup (closed)

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
                item == self.player.currentItem
            else { return }

            self.player.seek(to: .zero)
            self.player.play()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    func playIntro(
        named fileName: String,
        fileType: String = "mp4",
        in bundle: Bundle = .main,
        muted: Bool = true,
        rate: Float = 1.0,
        autoPlay: Bool = true
    ) {

        guard
            let url = bundle.url(forResource: fileName, withExtension: fileType)
        else {
            print("Intro video not found: \(fileName).\(fileType)")
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

    func stop() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
}
