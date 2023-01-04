import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    @DocumentID var id: String?
    @ServerTimestamp var createdTime: Timestamp?
    var result: Result
    var isHalfRound: Bool
    var isFourPeople: Bool
    var gameType: String
    var userId: String?
}

enum GameType: String, CaseIterable, Equatable {
    case fiveTen = "5-10"
    case oneTwo = "1-2"
    case oneThree = "1-3"
    case twoThree = "2-3"
}
