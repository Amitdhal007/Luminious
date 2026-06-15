import Foundation

/// Repository responsible for managing Session persistence.
///
/// Design intent:
/// - Abstracts data source (CoreData / API / cache)
/// - Provides CRUD operations for Session entity
/// - Keeps business logic out of persistence layer
///
/// Assumptions:
/// - Session is uniquely identified internally (e.g., id inside Session model)
/// - "Latest session" is defined by persistence ordering (e.g., timestamp)
protocol SessionRepository {

    /// Creates a new session in persistence layer
    func create(session: Session) async throws

    /// Fetches the most recently created/updated session
    func fetchLatest() async throws -> Session?

    /// Updates an existing session
    func update(session: Session) async throws

    /// Deletes a session by its identifier
    func delete(sessionId: UUID) async throws
}
