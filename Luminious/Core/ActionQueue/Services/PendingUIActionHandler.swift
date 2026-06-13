import Foundation

final class PendingUIActionHandler: PendingUIActionHandling {
    
    private(set) var pendingActions: [PendingUIAction] = []
    
    func enqueue(_ action: PendingUIAction) {
        
        guard pendingActions.contains(action) == false else {
            return
        }
        
        pendingActions.append(action)
    }
    
    func dequeue() -> PendingUIAction? {
        
        guard pendingActions.isEmpty == false else {
            return nil
        }
        
        return pendingActions.removeFirst()
    }
    
    func dequeueAll() -> [PendingUIAction] {
        
        let actions = pendingActions
        
        pendingActions.removeAll()
        
        return actions
    }
    
    func clear() {
        pendingActions.removeAll()
    }
}
