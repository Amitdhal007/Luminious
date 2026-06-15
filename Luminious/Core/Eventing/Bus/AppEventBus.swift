import Combine

/// A lightweight in-app event dispatcher used for decoupled communication
/// between modules (e.g., Coordinator, Services, ViewModels).
///
/// Design decisions:
/// - Uses Combine PassthroughSubject for event streaming
/// - Acts as a central event hub without storing state
/// - Events are fire-and-forget (no replay)
///
/// Assumptions:
/// - Events are consumed immediately by subscribers
/// - No need for historical event replay
/// - Subscribers manage their own lifecycle (e.g., cancellables)
final class AppEventBus: AppEventDispatching {

    // MARK: - Core Stream

    private let subject = PassthroughSubject<AppEvent, Never>()

    // MARK: - Public Stream

    var events: AnyPublisher<AppEvent, Never> {
        subject.eraseToAnyPublisher()
    }

    // MARK: - Emit

    func emit(_ event: AppEvent) {
        subject.send(event)
    }
}
