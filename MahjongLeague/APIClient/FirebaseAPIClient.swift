import Foundation
import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseAuth

struct FirebaseAPIClient {
    var signInAnonymously: @Sendable() async throws -> Void
    var loadGames: @Sendable () async throws -> GameResult
    
    init(
        signInAnonymously: @escaping @Sendable() async throws -> Void,
        loadGames: @escaping @Sendable () async throws -> GameResult
    ) {
        self.signInAnonymously = signInAnonymously
        self.loadGames = loadGames
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
                try? document.data(as: GameResult.Game.self)
            }
            return GameResult(results: games)
        }
    )
}

extension FirebaseAPIClient {
    enum FirestorePathComponent: String {
        case games = "games"
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
