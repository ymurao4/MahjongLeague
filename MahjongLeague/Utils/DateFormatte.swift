import Foundation

extension Date {
    func toString(format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
