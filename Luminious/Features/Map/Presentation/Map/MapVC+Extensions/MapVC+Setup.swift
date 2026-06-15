import UIKit

extension MapVC {

    public func initialSetup() {

        setupMapView()
        centerOnUserLocation()

        configureView()
        configureBindings()

        bindARButton()
        bindVehicleCountButton()

        setupSearchTap()
    }

    public func setupSearchTap() {

        addTapGesture(
            to: searchBarStackView,
            action: #selector(handleSearchTap)
        )

        searchBar.setInteractionEnabled(false)
        searchBarStackView.isUserInteractionEnabled = true
    }

    public func configureView() {

        configureSearchBar()

        configureARButton()

        configureVehicleCountButton()
    }
}
extension MapVC {

    @objc
    private func handleSearchTap() {

        let vehicles = viewModel.vehicles

        coordinator?
            .mapDidRequestVehicleSearch(
                vehicles: vehicles
            )
    }

    private func configureSearchBar() {

        searchBarStackView
            .addArrangedSubview(
                searchBar
            )
    }

    private func configureARButton() {

        arButton.heightAnchor.constraint(
            equalToConstant: 48
        ).isActive = true

        actionButtonsStackView.addArrangedSubview(arButton)
    }

    private func configureVehicleCountButton() {

        dynamicVehicleButton.heightAnchor.constraint(
            equalToConstant: 48
        ).isActive = true

        actionButtonsStackView.addArrangedSubview(dynamicVehicleButton)
    }
}
