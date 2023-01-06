import Foundation
import FirebaseFirestore
@preconcurrency import FirebaseFirestoreSwift

struct Record: Codable, Identifiable, Equatable, Sendable {
    @DocumentID var id: String?
    var results: [GameResult]

    struct GameResult: Codable, Identifiable, Equatable, Sendable {
        @DocumentID var id: String?
        var player: Player
        var score: String
    }
}
