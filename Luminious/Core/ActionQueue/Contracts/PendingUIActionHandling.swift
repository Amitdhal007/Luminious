import Foundation

protocol PendingUIActionHandling: AnyObject {
    
    var pendingActions: [PendingUIAction] { get }
    
    func enqueue(_ action: PendingUIAction)
    
    func dequeue() -> PendingUIAction?
    
    func dequeueAll() -> [PendingUIAction]
    
    func clear()
}
