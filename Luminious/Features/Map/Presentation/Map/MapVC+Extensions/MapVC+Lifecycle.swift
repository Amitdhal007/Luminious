import UIKit

extension MapVC {

    public func handleScreenWillAppear() {

        guard
            let sessionId =
                viewModel.currentSession?.id
        else {
            return
        }

        viewModel.startSimulation(
            sessionId: sessionId
        )
    }

    public func handleScreenWillDisappear() {

        viewModel.stopSimulation()
    }
}
