import Foundation
import SwiftUI
import FirebaseFirestore
@preconcurrency import FirebaseFirestoreSwift

struct GameResult: Codable, Equatable, Sendable {
    var results: [Game]
    
    struct Game: Codable, Identifiable, Equatable, Sendable {
        @DocumentID var id: String?
        @ServerTimestamp var createdTime: Timestamp?
        var result: Record
        var isHalfRound: Bool
        var isFourPeople: Bool
        var gameType: String
        var userId: String?
    }
}

enum GameType: String, CaseIterable, Equatable {
    case fiveTen = "5-10"
    case oneTwo = "1-2"
    case oneThree = "1-3"
    case twoThree = "2-3"
}

