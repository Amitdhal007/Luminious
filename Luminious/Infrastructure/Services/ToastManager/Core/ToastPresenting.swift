import Foundation

protocol ToastPresenting {
    
    func show(
        style: ToastStyle,
        title: String,
        subtitle: String?
    )
}
