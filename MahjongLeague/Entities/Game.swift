import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    
    @DocumentID var id: String?
    var players: [GamePlayer]
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
}
