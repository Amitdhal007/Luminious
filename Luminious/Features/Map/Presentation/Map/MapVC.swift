import Combine
import MapKit
import UIKit

final class MapVC: UIViewController {

    public var toast: ToastPresenting!
    public var viewModel: MapViewModel!
    public var loader: LoaderPresenting!
    public weak var coordinator: MapCoordinating?

    internal var cancellables =
        Set<AnyCancellable>()

    internal var mapView: MKMapView!

    internal let searchBar =
        LiquidGlassSearchBar()

    internal let arButton =
        LiquidGlassButton(
            image: UIImage(systemName: "arkit")
        )

    internal let dynamicVehicleButton =
        LiquidGlassButton(
            image: UIImage(systemName: "slider.horizontal.3")
        )

    @IBOutlet weak var actionButtonsStackView: UIStackView!
    @IBOutlet weak var searchBarStackView: UIStackView!
    @IBOutlet weak var mapContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        loadVehicles()
    }

    override func viewWillAppear(
        _ animated: Bool
    ) {
        super.viewWillAppear(animated)

        handleScreenWillAppear()
    }

    override func viewWillDisappear(
        _ animated: Bool
    ) {
        super.viewWillDisappear(animated)

        handleScreenWillDisappear()
    }
}
