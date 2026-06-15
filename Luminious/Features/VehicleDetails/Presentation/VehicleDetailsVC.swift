import MapKit
import SDWebImage
import UIKit

final class VehicleDetailsVC: UIViewController {

    public var toast: ToastPresenting!
    public var viewModel: VehicleDetailsViewModel!

    internal var vehicleAnnotation: PlayBackVehicleAnnotation?
    internal var startAnnotation: StartAnnotation?
    internal var endAnnotation: EndAnnotation?

    internal var fullRouteOverlay: MKPolyline?
    internal var progressOverlay: MKPolyline?

    internal var animatedCoordinates: [CLLocationCoordinate2D] = []

    internal var playbackAnimationTask: Task<Void, Never>?
    internal var routeLoadTask: Task<Void, Never>?

    @IBOutlet weak var glassContainerView: UIView!

    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var createdStatusButton: UIButton!
    @IBOutlet weak var runningStatusButton: UIButton!
    @IBOutlet weak var completedStatusButton: UIButton!

    @IBOutlet weak var vehicleNumberLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!

    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var fromTimeLabel: UILabel!

    @IBOutlet weak var toLocationLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!

    @IBOutlet weak var tripDateLabel: UILabel!

    @IBOutlet weak var playbackMapContainer: UIStackView!
    @IBOutlet weak var playbackMapView: MKMapView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    deinit {
        cleanup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewDidDisappear(
        _ animated: Bool
    ) {

        super.viewDidDisappear(
            animated
        )

        if isBeingDismissed || navigationController?.isBeingDismissed == true {

            cleanup()
        }
    }
}
extension VehicleDetailsVC {

    @IBAction func playTapped(
        _ sender:
            UIButton
    ) {

        handlePlay()
    }

    @IBAction func pauseTapped(
        _ sender:
            UIButton
    ) {

        handlePause()
    }

    @IBAction func stopTapped(
        _ sender:
            UIButton
    ) {

        handleStop()
    }
}
extension VehicleDetailsVC {

    private func handlePlay() {

        Task { [weak self] in

            guard let self
            else {
                return
            }

            await viewModel.startPlayback()

            await MainActor.run { [weak self] in

                guard let self
                else {
                    return
                }

                updatePlaybackButtons()
            }
        }
    }

    private func handlePause() {

        viewModel.pausePlayback()

        updatePlaybackButtons()
    }

    private func handleStop() {

        cancelPlaybackAnimation()

        viewModel.stopPlayback()

        clearProgressRoute()

        updatePlaybackButtons()
    }

    private func cancelPlaybackAnimation() {

        playbackAnimationTask?.cancel()
    }

    private func clearProgressRoute() {

        animatedCoordinates.removeAll()

        guard let progressOverlay
        else {
            return
        }

        playbackMapView.removeOverlay(
            progressOverlay
        )

        self.progressOverlay = nil
    }
}
