import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class PlayerRepository {

    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid

    @Published var player: [Player] = []

    init() {
        loadDate()
    }

    func loadDate() {

        db.collection("players")
            .whereField("userId", isEqualTo: userId as Any)
            .addSnapshotListener { querySnapshot, error in
                DispatchQueue.main.async {
                    if let querySnapshot = querySnapshot {
                        self.player = querySnapshot.documents.compactMap({ document in
                            do {
                                let x = try document.data(as: Player.self)
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

    func addPlayer(player: Player) {
        do {
            var addedPlayer = player
            addedPlayer.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("players").addDocument(from: addedPlayer)
        } catch {
            fatalError()
        }
    }
}
