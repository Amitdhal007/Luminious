import Combine
import CoreLocation
import UIKit

extension MapVC {

    public func bindARButton() {

        arButton
            .tapPublisher
            .sink { [weak self] _ in

                guard let self
                else {
                    return
                }

                coordinator?.mapDidRequestAR()
            }
            .store(
                in: &cancellables
            )
    }

    public func bindVehicleCountButton() {

        dynamicVehicleButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in

                guard let self
                else {
                    return
                }

                handleNewSessionTapped()
            }
            .store(in: &cancellables)
    }
}
extension MapVC {

    private func handleNewSessionTapped() {

        Task { @MainActor in

            guard
                viewModel.locationManager.isLocationEnabled()
            else {
                showLocationPermissionAlert()
                return
            }

            guard
                let vehicleCount = await showVehicleCountPicker()
            else {
                return
            }

            do {

                loader.show()
                defer { loader.hide() }

                let location = try await viewModel.locationManager
                    .getCurrentLocation()

                let session = try await viewModel.createNewSession(
                    vehicleCount: vehicleCount
                )

                try await viewModel.bootstrapSession(
                    session,
                    userLocation: .init(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                )

                guard
                    let session =
                        try await viewModel
                        .fetchCurrentSession()
                else {
                    return
                }

                viewModel.updateCurrentSession(session)

                let vehicles =
                    try await viewModel
                    .loadVehicles(
                        sessionId: session.id
                    )

                updateVehicleAnnotations(
                    vehicles
                )

                viewModel.startSimulation(
                    sessionId: session.id
                )

            } catch {

                toast.show(
                    style: .error,
                    title: SplashStrings.sessionCreationFailed,
                    subtitle: error.localizedDescription
                )
            }
        }
    }
}
