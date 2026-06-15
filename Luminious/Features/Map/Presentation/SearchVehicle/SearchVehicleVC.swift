import Combine
import UIKit

final class SearchVehicleVC: UIViewController {

    public var viewModel: SearchVehicleViewModel!

    internal var cancellables =
        Set<AnyCancellable>()

    internal var tableViewHandler: SearchVehicleTableViewDataSourceHandler!

    internal let closeButton =
        DarkGlassButton(
            image: UIImage(
                systemName: "xmark"
            )
        )

    internal let searchBar =
        DarkGlassSearchBar()

    @IBOutlet weak var glassContainerView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var headerStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
}
