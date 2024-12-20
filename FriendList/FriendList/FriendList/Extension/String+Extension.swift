import Foundation

extension String {
    func toDate(formats: [String]) -> Date? {
        let dateFormatter = DateFormatter()
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: self) {
                return date
            }
        }
        return nil
    }
}
