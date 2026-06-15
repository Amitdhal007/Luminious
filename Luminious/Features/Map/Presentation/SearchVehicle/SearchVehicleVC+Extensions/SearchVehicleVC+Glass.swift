import UIKit

extension SearchVehicleVC {

    public func setupGlassContainer() {

        let glassEffect = UIGlassEffect(
            style: .clear
        )

        glassEffect.tintColor = .white.withAlphaComponent(0.1)

        let glassContainer =
            UIVisualEffectView(
                effect: glassEffect
            )

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
