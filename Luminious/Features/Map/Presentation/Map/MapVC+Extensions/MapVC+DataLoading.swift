import UIKit

extension MapVC {

    public func loadVehicles() {

        Task { @MainActor [weak self] in
            
            guard let self else { return }

            do {

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
                    title: "Failed to Load Vehicles",
                    subtitle: error.localizedDescription
                )
            }
        }
    }
}
