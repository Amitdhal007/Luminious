import Foundation

protocol SplashFactory {

    func makeSplashScreen(
        coordinator: SplashCoordinating
    ) -> SplashVC
}
