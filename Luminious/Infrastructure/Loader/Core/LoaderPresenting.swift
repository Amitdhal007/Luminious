import Foundation

protocol LoaderPresenting: AnyObject {

    func show()
    func hide()

    var isVisible: Bool { get }
}
