import UIKit

extension SearchVehicleVC {

    public func setupHeader() {

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
