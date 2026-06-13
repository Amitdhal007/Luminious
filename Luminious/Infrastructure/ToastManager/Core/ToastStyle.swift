import UIKit

public enum ToastStyle {
    
    case success
    case error
    case warning
    case info
}
extension ToastStyle {

    var symbolName: String {

        switch self {

        case .success:
            return "checkmark.seal.fill"

        case .error:
            return "xmark.circle.fill"

        case .warning:
            return "exclamationmark.triangle.fill"

        case .info:
            return "sparkles"
        }
    }

    var tintColor: UIColor {

        switch self {

        case .success:
            return .systemGreen

        case .error:
            return .white

        case .warning:
            return .systemOrange

        case .info:
            return .systemBlue
        }
    }
}
extension ToastStyle {

    var feedbackType: UINotificationFeedbackGenerator.FeedbackType {

        switch self {

        case .success:
            return .success

        case .error:
            return .error

        case .warning:
            return .warning

        case .info:
            return .success
        }
    }
}
