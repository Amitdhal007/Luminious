import Foundation

/// Centralized storyboard identifiers used for navigation and scene loading.
///
/// Design intent:
/// - Avoid stringly-typed storyboard names
/// - Provide compile-time safety for storyboard references
/// - Improve maintainability as app scales
enum Storyboard: String {

    case splash = "Splash"
    case map = "Map"
}
