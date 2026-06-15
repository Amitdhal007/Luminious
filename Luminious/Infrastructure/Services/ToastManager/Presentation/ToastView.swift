import UIKit

public protocol ToastView : UIView {
    func createView(for toast: Toast)
}
