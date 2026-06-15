import UIKit

public enum ToastStyle {

    case success
    case error
    case warning
    case info
}

// MARK: - Icons

extension ToastStyle {

    var symbolName: String {

        switch self {

        case .success:
            return "checkmark.circle.fill"

        case .error:
            return "xmark.circle.fill"

        case .warning:
            return "exclamationmark.triangle.fill"

        case .info:
            return "sparkles"
        }
    }

}

// MARK: - Colors

extension ToastStyle {

    var tintColor: UIColor {

        switch self {

        case .success:
            return UIColor(
                red: 0.22,
                green: 0.92,
                blue: 0.62,
                alpha: 1
            )

        case .error:
            return UIColor(
                red: 1,
                green: 0.34,
                blue: 0.40,
                alpha: 1
            )

        case .warning:
            return UIColor(
                red: 1,
                green: 0.72,
                blue: 0.22,
                alpha: 1
            )

        case .info:
            return UIColor(
                red: 0.36,
                green: 0.74,
                blue: 1,
                alpha: 1
            )
        }
    }

    /// Glass background
    var backgroundColor: UIColor {

        UIColor(
            white: 0.10,
            alpha: 0.70
        )
    }

    /// Blur style
    var blurStyle: UIBlurEffect.Style {

        .systemUltraThinMaterialDark
    }

    /// Border

    var borderColor: UIColor {

        tintColor
            .withAlphaComponent(
                0.25
            )
    }

    /// Glow

    var shadowColor: UIColor {

        tintColor
            .withAlphaComponent(
                0.45
            )
    }

    /// Text

    var textColor: UIColor {

        .white
    }

}

// MARK: - Haptic

extension ToastStyle {

    var feedbackType:
        UINotificationFeedbackGenerator
            .FeedbackType
    {

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
