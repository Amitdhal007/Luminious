import Combine
import UIKit

final class SearchVehicleVC: UIViewController {

    public var viewModel: SearchVehicleViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var tableViewHandler: SearchVehicleTableViewDataSourceHandler!

    private let glassContainer =
        UIVisualEffectView(
            effect: UIGlassEffect(
                style: .clear
            )
        )

    private let closeButton =
    DarkGlassButton(
            image: UIImage(
                systemName: "xmark"
            )
        )

    private let searchBar =
    DarkGlassSearchBar()

    @IBOutlet weak var glassContainerView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var headerStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
}

private extension SearchVehicleVC {

    func initialSetup() {

        configureView()

        configureTableView()

        bindViewModel()

        bindSearchBar()

        bindCloseButton()
    }

    func configureView() {

        view.backgroundColor =
            .clear

        setupGlassContainer()

        setupHeader()
    }
}
private extension SearchVehicleVC {

    func setupGlassContainer() {

        glassContainer.translatesAutoresizingMaskIntoConstraints =
            false

        glassContainerView.addSubview(
            glassContainer
        )

        NSLayoutConstraint.activate([

            glassContainer.topAnchor.constraint(
                equalTo: glassContainerView.topAnchor
            ),

            glassContainer.leadingAnchor.constraint(
                equalTo: glassContainerView.leadingAnchor
            ),

            glassContainer.trailingAnchor.constraint(
                equalTo: glassContainerView.trailingAnchor
            ),

            glassContainer.bottomAnchor.constraint(
                equalTo: glassContainerView.bottomAnchor
            ),
        ])
    }
}

private extension SearchVehicleVC {

    func setupHeader() {

        headerStackView.axis =
            .horizontal

        headerStackView.spacing =
            10

        headerStackView.alignment =
            .center

        headerStackView.addArrangedSubview(
            searchBar
        )

        headerStackView.addArrangedSubview(
            closeButton
        )

        closeButton.widthAnchor.constraint(
            equalTo: closeButton.heightAnchor,
            multiplier: 1
        ).isActive = true
    }
}

private extension SearchVehicleVC {

    func configureTableView() {

        searchTableView.register(
            SearchVehicleTableViewCell.self,
            forCellReuseIdentifier:
                SearchVehicleTableViewCell
                .reuseIdentifier
        )

        tableViewHandler =
            SearchVehicleTableViewDataSourceHandler(
                viewModel: viewModel
            )

        searchTableView.dataSource =
            tableViewHandler

        searchTableView.delegate =
            tableViewHandler

        searchTableView.rowHeight =
            UITableView.automaticDimension

        searchTableView.estimatedRowHeight =
            80

        searchTableView.showsVerticalScrollIndicator =
            false
    }
}

private extension SearchVehicleVC {

    func bindViewModel() {

        viewModel.$vehicles
            .receive(
                on: DispatchQueue.main
            )
            .sink { [weak self] _ in

                self?.searchTableView
                    .reloadData()
            }
            .store(
                in: &cancellables
            )
    }

    func bindSearchBar() {

        searchBar.actionPublisher
            .sink { [weak self] action in

                guard let self
                else {
                    return
                }

                switch action {

                case .textChanged(
                    let text
                ):

                    viewModel.search(
                        query: text
                    )

                case .searchSubmitted(
                    let text
                ):

                    viewModel.search(
                        query: text
                    )

                case .clearTapped:

                    viewModel.search(
                        query: ""
                    )
                }
            }
            .store(
                in: &cancellables
            )
    }

    func bindCloseButton() {

        closeButton.tapPublisher
            .sink { [weak self] _ in

                self?.dismiss(
                    animated: true
                )
            }
            .store(
                in: &cancellables
            )
    }
}
