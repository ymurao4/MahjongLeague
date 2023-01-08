import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseAuth

struct FirebaseAPIClient {
    var signInAnonymously: @Sendable() async throws -> Void
    var loadGames: @Sendable () async throws -> GameResult
    var loadPlayers: @Sendable () async throws -> PlayerResult
    var submitGame: @Sendable (_ game: Game) async throws -> None
    
    init(
        signInAnonymously: @escaping @Sendable() async throws -> Void,
        loadGames: @escaping @Sendable () async throws -> GameResult,
        loadPlayers: @escaping @Sendable () async throws -> PlayerResult,
        submitGame: @escaping @Sendable (_ game: Game) async throws -> None
    ) {
        self.signInAnonymously = signInAnonymously
        self.loadGames = loadGames
        self.loadPlayers = loadPlayers
        self.submitGame = submitGame
    }
}

extension FirebaseAPIClient {
    static var appUser: AppUser = .init(id: "", name: "", status: .uninitialized)
    static let db: Firestore = Firestore.firestore()
    
    static let live = Self(
        signInAnonymously: {
            Auth.auth().signInAnonymously()
                .map { result in
                    let appUser: AppUser = .init(from: result.user)
                    FirebaseAPIClient.appUser = appUser
                    return None()
                }
                .mapError { error in
                    APIError.init(error: error)
                }
                .eraseToEffect()
        }, loadGames: {
            guard let userId = Auth.auth().currentUser?.uid else { return GameResult(results: []) }

            let snapShot = try await db.collection(FirestorePathComponent.games.rawValue)
                .whereField(FirestorePathComponent.userId.rawValue, isEqualTo: userId as Any)
                .order(by: FirestorePathComponent.createdTime.rawValue, descending: true)
                .getDocuments()
            var games = snapShot.documents.compactMap { document in
                try? document.data(as: Game.self)
            }
            return GameResult(results: games)
        }, loadPlayers: {
            guard let userId = Auth.auth().currentUser?.uid else { return PlayerResult(players: [])}
            let snapShot = try await db.collection(FirestorePathComponent.players.rawValue)
//                .whereField(FirestorePathComponent.userId.rawValue, isEqualTo: userId as Any)
                .order(by: FirestorePathComponent.createdTime.rawValue, descending: false)
                .getDocuments()
            var players = snapShot.documents.compactMap { document in
                try? document.data(as: Player.self)
            }
            return PlayerResult(players: players)
        }, submitGame: { game in
            guard let userId = Auth.auth().currentUser?.uid else { return None() }
            var addedGame = game
            addedGame.userId = userId
            let _ = try await db.collection(FirestorePathComponent.games.rawValue)
                .addDocument(from: addedGame)
            return None()
        }
    )
}

extension FirebaseAPIClient {
    enum FirestorePathComponent: String {
        case games = "games"
        case players = "players"
        case user = "user"
        case userId = "userId"
        case createdTime = "createdTime"
    }
}

private let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  let formatter = DateFormatter()
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.dateFormat = "yyyy-MM-dd"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  decoder.dateDecodingStrategy = .formatted(formatter)
  return decoder
}()

private enum APIClientKey: DependencyKey {
    static let liveValue = FirebaseAPIClient.live
}

extension DependencyValues {
    var firebaseAPIClient: FirebaseAPIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}
