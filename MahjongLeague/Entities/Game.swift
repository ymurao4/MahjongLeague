import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    
    @DocumentID var id: String?
    var players: [GamePlayer]
    var userId: String?
}

struct GamePlayer: Codable, Identifiable {
    
    @DocumentID var id: String?
    let name: String
    let score: Int
    let order: Int
}
