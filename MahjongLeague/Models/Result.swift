import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Result: Codable, Identifiable {
    @DocumentID var id: String?
    var results: [GameResult]

    struct GameResult: Codable, Identifiable {
        @DocumentID var id: String?
        var player: Player
        var score: String
    }
}
