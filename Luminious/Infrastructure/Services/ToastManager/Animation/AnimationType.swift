import UIKit

extension Toast {

    public enum AnimationType {

        case slide(x: CGFloat, y: CGFloat)

        case fade(alpha: CGFloat)
        
        case scaleAndSlide(scaleX: CGFloat, scaleY: CGFloat, x: CGFloat, y: CGFloat)
        
        case scale(scaleX: CGFloat, scaleY: CGFloat)
        
        case custom(transformation: CGAffineTransform)
        
        case `default`
        
        func apply(to view: UIView) {
            switch self {
            case .slide(x: let x, y: let y):
                view.transform = CGAffineTransform(translationX: x, y: y)
                
            case .fade(let value):
                view.alpha = value
                
            case .scaleAndSlide(let scaleX, let scaleY, let x, let y):
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY).translatedBy(x: x, y: y)
                
            case .scale(let scaleX, let scaleY):
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                
            case .custom(let transformation):
                view.transform = transformation
                
            case .`default`:
                break
            }
        }

        func undo(from view: UIView) {
            switch self {
            case .slide, .scaleAndSlide, .scale, .custom:
                view.transform = .identity
                
            case .fade:
                view.alpha = 1.0
                
            case .`default`:
                break
            }
        }
    }
}
