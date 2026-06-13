import Foundation

protocol SplashCoordinating: AnyObject {

    func splashDidRequestResumeSession()

    func splashDidCreateNewSession(
        _ session: Session
    )
}
