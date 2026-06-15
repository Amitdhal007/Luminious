import Foundation

public enum LiquidGlassSearchBarAction: Sendable {
    
    case textChanged(String)
    case searchSubmitted(String)
    case clearTapped
}
