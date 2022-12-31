import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    @DocumentID var id: String?
    @ServerTimestamp var createdTime: Timestamp?
    var result: Result
    var isHalfround: Bool
    var userId: String?
}

