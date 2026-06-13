import UIKit

extension UIImage {

    func resized(
        maxWidth: CGFloat,
        scale: CGFloat = 1
    ) -> UIImage {

        let aspectRatio = size.height / size.width

        let newSize = CGSize(
            width: maxWidth,
            height: maxWidth * aspectRatio
        )

        UIGraphicsBeginImageContextWithOptions(
            newSize,
            false,
            scale
        )

        draw(in: CGRect(origin: .zero, size: newSize))

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image ?? self
    }

    func resized(to size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
