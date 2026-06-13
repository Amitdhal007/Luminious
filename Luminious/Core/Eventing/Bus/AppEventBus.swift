import Combine

final class AppEventBus: AppEventDispatching {

    private let subject = PassthroughSubject<AppEvent, Never>()

    var events: AnyPublisher<AppEvent, Never> {
        subject.eraseToAnyPublisher()
    }

    func emit(_ event: AppEvent) {
        subject.send(event)
    }
}
