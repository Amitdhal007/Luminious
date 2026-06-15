import UIKit

// MARK: - UITextField Placeholder Color
extension UITextField {

    @IBInspectable var placeHolderColor: UIColor? {
        get { return self.placeHolderColor }
        set {
            guard let newValue = newValue else { return }
            let text = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [.foregroundColor: newValue]
            )
        }
    }
}

// MARK: - UIView Rounded Property
extension UIView {

    private struct AssociatedKey {
        static var rounded = "UIView.rounded"
    }

    @IBInspectable var rounded: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.rounded)
                as? Bool ?? false
        }
        set {
            DispatchQueue.main.async {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKey.rounded,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                self.layer.cornerRadius =
                    newValue
                    ? min(self.bounds.width, self.bounds.height) / 2
                    : 0
            }
        }
    }
}

// For IBDesignable
@IBDesignable
class CustomView: UIView {}

// MARK: - UIView Border, Shadow, Corner
extension UIView {

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            guard let cgColor = layer.shadowColor else { return .clear }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var maskToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }

    @IBInspectable var cornerradius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    func setViewCircle() {
        layer.cornerRadius = bounds.size.height / 2.0
        clipsToBounds = true
    }
}

// MARK: - UIView Corner Mask
extension UIView {

    private struct AssociatedKeys {
        static var topLeft = "topLeft"
        static var topRight = "topRight"
        static var bottomLeft = "bottomLeft"
        static var bottomRight = "bottomRight"
    }

    @IBInspectable var topLeft: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.topLeft)
                as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.topLeft,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            updateCorners()
        }
    }

    @IBInspectable var topRight: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.topRight)
                as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.topRight,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            updateCorners()
        }
    }

    @IBInspectable var bottomLeft: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.bottomLeft)
                as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.bottomLeft,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            updateCorners()
        }
    }

    @IBInspectable var bottomRight: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.bottomRight)
                as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.bottomRight,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            updateCorners()
        }
    }

    private func updateCorners() {
        var maskedCorners: CACornerMask = []
        if topLeft { maskedCorners.insert(.layerMinXMinYCorner) }
        if topRight { maskedCorners.insert(.layerMaxXMinYCorner) }
        if bottomLeft { maskedCorners.insert(.layerMinXMaxYCorner) }
        if bottomRight { maskedCorners.insert(.layerMaxXMaxYCorner) }

        layer.maskedCorners = maskedCorners
        layer.masksToBounds = true
    }
}

extension CGPoint {
    
    public enum CoordinateSide {
        case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft,
            left
    }

    public static func unitCoordinate(_ side: CoordinateSide) -> CGPoint {
        switch side {
        case .topLeft: return CGPoint(x: 0.0, y: 0.0)
        case .top: return CGPoint(x: 0.5, y: 0.0)
        case .topRight: return CGPoint(x: 1.0, y: 0.0)
        case .right: return CGPoint(x: 1.0, y: 0.5)
        case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
        case .bottom: return CGPoint(x: 0.5, y: 1.0)
        case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
        case .left: return CGPoint(x: 0.0, y: 0.5)
        }
    }
}

// MARK: - UILabel Underline
private var underlineKey: UInt8 = 0

extension UILabel {
    
    @IBInspectable var isUnderlined: Bool {
        get {
            return objc_getAssociatedObject(self, &underlineKey) as? Bool
                ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &underlineKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            applyUnderline()
        }
    }

    private func applyUnderline() {
        guard let labelText = text else { return }

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: textColor ?? UIColor.black,
            .underlineStyle: isUnderlined
                ? NSUnderlineStyle.single.rawValue : 0,
        ]
        attributedText = NSAttributedString(
            string: labelText,
            attributes: attributes
        )
    }

    func refreshUnderline() {
        applyUnderline()
    }
}

// MARK: - UIButton Underline
private var underlineKeyButton: UInt8 = 0

extension UIButton {
    
    @IBInspectable var isUnderlined: Bool {
        get {
            return objc_getAssociatedObject(self, &underlineKeyButton) as? Bool
                ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &underlineKeyButton,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            applyUnderline()
        }
    }

    private func applyUnderline() {
        guard let title = title(for: .normal),
            let titleLabel = titleLabel
        else { return }

        let attributes: [NSAttributedString.Key: Any] = [
            .font: titleLabel.font ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: titleColor(for: .normal) ?? UIColor.black,
            .underlineStyle: isUnderlined
                ? NSUnderlineStyle.single.rawValue : 0,
        ]
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: attributes
        )
        setAttributedTitle(attributedTitle, for: .normal)
    }

    func refreshUnderline() {
        applyUnderline()
    }
}
