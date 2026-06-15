import CoreData

protocol CoreDataContextProvider {

    var viewContext:
        NSManagedObjectContext { get }

    func newBackgroundContext()
        -> NSManagedObjectContext

    func save(
        context: NSManagedObjectContext
    ) throws

    func saveContext() throws
}
