import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Result: Codable, Identifiable {
    @DocumentID var id: String?
    var results: [String: String]
}
