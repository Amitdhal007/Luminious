import UIKit

extension SearchVehicleVC {

    public func initialSetup() {

        configureView()

        configureTableView()

        bindViewModel()

        bindSearchBar()

        bindCloseButton()
    }

    public func configureView() {

        view.backgroundColor =
            .clear

        setupGlassContainer()

        setupHeader()
    }
}
