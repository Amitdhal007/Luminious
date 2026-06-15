import CoreData

final class CoreDataStack:
    CoreDataContextProvider {

    private let container:
        NSPersistentContainer

    init() {

        container =
            NSPersistentContainer(
                name: "VehicleTracking"
            )

        guard let description =
            container
                .persistentStoreDescriptions
                .first
        else {
            fatalError(
                "Missing persistent store description"
            )
        }

        description
            .shouldMigrateStoreAutomatically = true

        description
            .shouldInferMappingModelAutomatically = true

        container.loadPersistentStores {
            _,
            error in

            if let error {
                fatalError(
                    error.localizedDescription
                )
            }
        }

        container
            .viewContext
            .automaticallyMergesChangesFromParent = true

        container
            .viewContext
            .mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy

        container
            .viewContext
            .undoManager = nil
    }

    var viewContext:
        NSManagedObjectContext {

        container.viewContext
    }

    func newBackgroundContext()
        -> NSManagedObjectContext {

        let context =
            container.newBackgroundContext()

        context.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy

        context.undoManager = nil

        return context
    }

    func save(
        context: NSManagedObjectContext
    ) throws {

        guard context.hasChanges else {
            return
        }

        try context.save()
    }
    
    func saveContext() throws {

        try save(
            context: viewContext
        )
    }
}
