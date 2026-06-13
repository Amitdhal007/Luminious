import Foundation

public protocol HeadingSensorDelegate: AnyObject {
    func didUpdateRawHeading(_ heading: CGFloat)
}
