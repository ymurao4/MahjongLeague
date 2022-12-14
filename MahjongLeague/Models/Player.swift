import Foundation
import FirebaseFirestore
@preconcurrency import FirebaseFirestoreSwift

struct PlayerResult: Codable, Equatable, Sendable {
    var players: [Player]
}

struct Player: Codable, Identifiable, Equatable, Sendable {
    @DocumentID var id: String?
    var name: String
    var userId: String?
    @ServerTimestamp var createdTime: Timestamp?
}
