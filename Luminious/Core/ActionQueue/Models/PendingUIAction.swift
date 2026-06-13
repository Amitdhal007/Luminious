import Foundation

enum PendingUIAction: Equatable {
    
    case reloadData
    
    case navigation(
        destination: NavigationDestination,
        style: NavigationStyle
    )
}
