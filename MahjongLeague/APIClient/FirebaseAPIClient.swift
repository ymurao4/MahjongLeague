import Combine
import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseAuth

struct FirebaseAPIClient {
    var signInAnonymously: () -> Effect<None, APIError>
    var loadData: () -> Effect<[Game], Never>
    
    init(
        signInAnonymously: @escaping () -> Effect<None, APIError>,
        loadData: @escaping () -> Effect<[Game], Never>
    ) {
        self.signInAnonymously = signInAnonymously
        self.loadData = loadData
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
        }, loadData: {
            var games: [Game] = []
            if let userId = Auth.auth().currentUser?.uid {
                db.collection(FirestorePathComponent.games.rawValue)
                    .whereField(FirestorePathComponent.userId.rawValue, isEqualTo: userId as Any)
                    .order(by: FirestorePathComponent.createdTime.rawValue, descending: true)
                    .addSnapshotListener { querySnapshot, error in
                        DispatchQueue.main.async {
                            if let querySnapshot = querySnapshot {
                                DispatchQueue.main.async {
                                    games = querySnapshot.documents.compactMap({ document in
                                        do {
                                            let x = try document.data(as: Game.self)
                                            return x
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                        return nil
                                    })
                                }
                            }
                        }
                    }
            }
            return EffectPublisher(value: games)
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
