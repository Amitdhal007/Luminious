import CoreData

extension NSManagedObjectContext {

    func performAsync<T>(
        _ block: @escaping () throws -> T
    ) async throws -> T {
        try await withCheckedThrowingContinuation {
            continuation in

            perform {

                do {
                    continuation.resume(
                        returning: try block()
                    )
                } catch {
                    continuation.resume(
                        throwing: error
                    )
                }
            }
        }
    }
}
