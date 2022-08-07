import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct GamePlayer: Codable, Identifiable {
    
    @DocumentID var id: String?
    let name: String
    let score: Int
}
