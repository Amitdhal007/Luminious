import Combine

protocol AppEventDispatching {
    
    var events: AnyPublisher<AppEvent, Never> { get }
    
    func emit(_ event: AppEvent)
}
