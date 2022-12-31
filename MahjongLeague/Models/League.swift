import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct League: Codable, Identifiable {
    
    @DocumentID var id: String?
    var name: String
    var players: [Player]
    var gameCount: Int?
    var games: [Game]
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
}