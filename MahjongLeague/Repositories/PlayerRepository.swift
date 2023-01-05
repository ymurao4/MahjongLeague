import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class PlayerRepository {
    
    let db = Firestore.firestore()
    
    @Published var player: [Player] = []
    
    init() {
        loadDate()
    }
    
    func loadDate() {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("players")
                .whereField("userId", isEqualTo: userId as Any)
                .order(by: "createdTime", descending: false)
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
    }
    
    func addPlayer(player: Player) {
        do {
            var addedPlayer = player
            addedPlayer.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("players").addDocument(from: addedPlayer)
            self.loadDate()
        } catch {
            fatalError()
        }
    }
    
    func updatePlayer(player: Player) {
        if let playerId = player.id {
            do {
                try db.collection("players").document(playerId).setData(from: player)
            } catch {
                fatalError("Unable to encode note: \(error)")
            }
        }
    }
    
    func deletePlayer(playerId: String) {
        db.collection("players").document(playerId).delete() { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted!")
                self.loadDate()
            }
        }
    }
}
