import Foundation

protocol SessionRepository {

    func create(
        session: Session
    ) async throws

    func fetchLatest()
    async throws -> Session?

    func update(
        session: Session
    ) async throws

    func delete(
        sessionId: UUID
    ) async throws
}
