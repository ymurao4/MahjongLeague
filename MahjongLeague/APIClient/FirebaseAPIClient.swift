import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseAuth

struct FirebaseAPIClient {
    var signInAnonymously: @Sendable() async throws -> Void
    var loadGames: @Sendable () async throws -> AsyncThrowingStream<GameResult, Error>
    var submitGame: @Sendable (_ game: Game) async throws -> None
    var deleteGame: @Sendable (_ gameId: String) async throws -> None
    var loadPlayers: @Sendable () async throws -> AsyncThrowingStream<PlayerResult, Error>
    var submitPlayer: @Sendable (_ player: Player) async throws -> None
    var deletePlayer: @Sendable (_ playerId: String) async throws -> None
    
    init(
        signInAnonymously: @escaping @Sendable() async throws -> Void,
        loadGames: @escaping @Sendable () async throws -> AsyncThrowingStream<GameResult, Error>,
        submitGame: @escaping @Sendable (_ game: Game) async throws -> None,
        deleteGame: @escaping @Sendable (_ gameId: String) async throws -> None,
        loadPlayers: @escaping @Sendable () async throws -> AsyncThrowingStream<PlayerResult, Error>,
        submitPlayer: @escaping @Sendable (_ player: Player) async throws -> None,
        deletePlayer: @escaping @Sendable (_ playerId: String) async throws -> None
    ) {
        self.signInAnonymously = signInAnonymously
        self.loadGames = loadGames
        self.submitGame = submitGame
        self.deleteGame = deleteGame
        self.loadPlayers = loadPlayers
        self.submitPlayer = submitPlayer
        self.deletePlayer = deletePlayer
    }
}

extension FirebaseAPIClient {
    static var appUser: AppUser = .init(id: "", name: "", status: .uninitialized)
    static let db: Firestore = Firestore.firestore()
    static let userId = Auth.auth().currentUser?.uid
    
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
            AsyncThrowingStream { continuation in
                let listener = db.collection(FirestorePathComponent.games.rawValue)
                    .whereField(FirestorePathComponent.userId.rawValue, isEqualTo: userId as Any)
                    .order(by: FirestorePathComponent.createdTime.rawValue, descending: true)
                    .addSnapshotListener { querySnapshot, error in
                        if let error {
                            continuation.finish(throwing: error)
                        }
                        if let querySnapshot {
                            do {
                                let games = try querySnapshot.documents.compactMap { document in
                                    try document.data(as: Game.self)
                                }
                                let states = GameResult(results: games)
                                continuation.yield(states)
                            } catch {
                                continuation.finish(throwing: error)
                            }
                        }
                    }
                continuation.onTermination = { @Sendable _ in
                    listener.remove()
                }
            }
        }, submitGame: { game in
            var addedGame = game
            addedGame.userId = userId
            let _ = try db.collection(FirestorePathComponent.games.rawValue)
                .addDocument(from: addedGame)
            return None()
        }, deleteGame: { id in
            let _ = db.collection(FirestorePathComponent.games.rawValue)
                .document(id)
                .delete() { error in
                    if let error {
                    } else {
                    }
                }
            return None()
        }, loadPlayers: {
            AsyncThrowingStream { continuation in
                let listener = db.collection(FirestorePathComponent.players.rawValue)
                    .whereField(FirestorePathComponent.userId.rawValue, isEqualTo: userId as Any)
                    .order(by: FirestorePathComponent.createdTime.rawValue, descending: false)
                    .addSnapshotListener { querySnapshot, error in
                        if let error {
                            continuation.finish(throwing: error)
                        }
                        if let querySnapshot {
                            do {
                                let players = try querySnapshot.documents.compactMap { document in
                                    try document.data(as: Player.self)
                                }
                                let states = PlayerResult(players: players)
                                continuation.yield(states)
                            } catch {
                                continuation.finish(throwing: error)
                            }
                        }
                    }
                continuation.onTermination = { @Sendable _ in
                    listener.remove()
                }
            }
        }, submitPlayer: { player in
            var addedPlayer = player
            addedPlayer.userId = userId
            let _ = try db.collection(FirestorePathComponent.players.rawValue)
                .addDocument(from: addedPlayer)
            return None()
        }, deletePlayer: { id in
            let _ = db.collection(FirestorePathComponent.players.rawValue)
                .document(id)
                .delete() { error in
                    
                }
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
