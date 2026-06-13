import Foundation

public protocol CompassEngineDelegate: AnyObject {
    func didUpdateHeading(_ heading: CompassHeading)
}
