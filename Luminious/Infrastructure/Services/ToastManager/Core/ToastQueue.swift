import Foundation

public class ToastQueue {

    private var queue: [Toast]
    private var isShowing = false

    public init(toasts: [Toast] = []) {
        self.queue = toasts
    }

    public func enqueue(_ toast: Toast) {
        queue.append(toast)
    }

    public func enqueue(_ toasts: [Toast]) {
        let size = queue.count
        toasts.forEach({ queue.append($0) })

        if size == 0 && isShowing {
            show()
        }
    }

    public func dequeue(_ toastToDequeue: Toast) {
        let index: Int? = queue.firstIndex { $0 === toastToDequeue }

        if let index {
            queue.remove(at: index)
        }
    }

    public func size() -> Int {
        return queue.count
    }

    public func show() {
        show(index: 0)
    }

    private func show(index: Int, after: Double = 0.0) {
        isShowing = true
        if queue.isEmpty {
            return
        }

        let toast: Toast = queue.remove(at: index)
        let delegate = QueuedToastDelegate(queue: self)

        toast.show(after: after)
    }

    private class QueuedToastDelegate {

        private var queue: ToastQueue

        public init(queue: ToastQueue) {
            self.queue = queue
        }

        public func didCloseToast(_ toast: Toast) {
            queue.show(index: 0, after: 0.5)
        }
    }
}
