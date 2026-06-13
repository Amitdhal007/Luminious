import Foundation

enum NavigationDestination: Equatable {
    
    case paywall
    
    case settings
    
    case lakeDetails(id: String)
}
