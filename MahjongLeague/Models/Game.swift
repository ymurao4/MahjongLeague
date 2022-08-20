import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    
    @DocumentID var id: String?
    var game: [String: Int]
    var order: [String: Int]
    var players: [Player]
    var userId: String?
}

