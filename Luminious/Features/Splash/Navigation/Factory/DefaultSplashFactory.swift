import Foundation

final class DefaultSplashFactory: SplashFactory {

    private let sessionRepository: SessionRepository

    private let toast: ToastPresenting

    init(
        sessionRepository: SessionRepository,
        toast: ToastPresenting
    ) {

        self.sessionRepository = sessionRepository
        self.toast = toast
    }

    func makeSplashScreen(
        coordinator: SplashCoordinating
    ) -> SplashVC {

        let vc =
            SplashVC.getVC(from: .splash)

        vc.coordinator = coordinator

        vc.toast = toast

        vc.viewModel = SplashViewModel(
            sessionRepository: sessionRepository
        )

        return vc
    }
}
