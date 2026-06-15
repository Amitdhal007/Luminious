import Combine

/// A protocol defining a unidirectional event dispatching system.
///
/// Responsibilities:
/// - Emit application events
/// - Expose a reactive event stream for subscribers
///
/// Design intent:
/// - Decouple producers (UI/Services) from consumers (Coordinators/ViewModels)
/// - Enable reactive, event-driven architecture using Combine
protocol AppEventDispatching {

    /// Stream of all application events
    var events: AnyPublisher<AppEvent, Never> { get }

    /// Emits a new application event into the system
    func emit(_ event: AppEvent)
}
