import Foundation

extension Array where Element == String {
    func removeDuplicates() -> [String] {
        reduce(into: [String]()) { result, element in
            if result.last != element {
                result.append(element)
            }
        }
    }
}
