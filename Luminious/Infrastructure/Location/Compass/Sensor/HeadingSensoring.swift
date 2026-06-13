import Foundation

public protocol HeadingSensoring: AnyObject {
    var delegate: HeadingSensorDelegate? { get set }
    func start()
    func stop()
}
