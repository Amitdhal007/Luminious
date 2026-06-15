import UIKit

extension UIViewController: Storyboarded {}

extension Storyboarded where Self: UIViewController {
    
    static func getVC(from storyboardName: StoryBoard) -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: Bundle.main)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self
        else {
            fatalError("No storyboard with this identifier: \(storyboardIdentifier)")
        }
        
        return nextVC
    }
    
    static func pop(from currentViewController: UIViewController, animated: Bool = true) {
        currentViewController.navigationController?.popViewController(animated: animated)
    }
    
    static func popToRoot(from currentViewController: UIViewController, animated: Bool = true) {
        currentViewController.navigationController?.popToRootViewController(animated: animated)
    }
}
