import Combine
import Foundation

protocol VehicleSimulationService {

    var vehiclesPublisher:
        AnyPublisher<[Vehicle], Never> { get }

    func start(
        sessionId: UUID
    )

    func stop()
}
