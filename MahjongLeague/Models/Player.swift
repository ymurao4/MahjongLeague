import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Player: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var userId: String?
    @ServerTimestamp var createdTime: Timestamp?
}
