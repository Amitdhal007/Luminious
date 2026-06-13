final class DefaultSplashFactory: SplashFactory {

    private let sessionRepository: SessionRepository
    private let sessionBootstrapService: SessionBootstrapService
    private let locationProvider: LocationProviding
    private let toast: ToastPresenting

    init(
        sessionRepository: SessionRepository,
        sessionBootstrapService: SessionBootstrapService,
        locationProvider: LocationProviding,
        toast: ToastPresenting
    ) {
        self.sessionRepository = sessionRepository
        self.sessionBootstrapService = sessionBootstrapService
        self.locationProvider = locationProvider
        self.toast = toast
    }

    func makeSplashScreen(
        coordinator: SplashCoordinating
    ) -> SplashVC {

        let vc = SplashVC.getVC(from: .splash)

        vc.coordinator = coordinator
        vc.toast = toast

        vc.viewModel = SplashViewModel(
            sessionRepository: sessionRepository,
            sessionBootstrapService: sessionBootstrapService,
            locationProvider: locationProvider
        )

        return vc
    }
}
