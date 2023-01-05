import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class GameRepository {
    
    let db = Firestore.firestore()

    @Published var game = [Game]()
    
    init() {
        loadDate()
    }
    
    func loadDate() {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("games")
                .whereField("userId", isEqualTo: userId as Any)
                .order(by: "createdTime", descending: true)
                .addSnapshotListener { querySnapshot, error in
                    DispatchQueue.main.async {
                        if let querySnapshot = querySnapshot {
                            DispatchQueue.main.async {
                                self.game = querySnapshot.documents.compactMap({ document in
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
    }
    
    func addGame(game: Game) {
        do {
            var addedGame = game
            addedGame.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("games").addDocument(from: addedGame)
        } catch {
            fatalError()
        }
    }
    
    func deleteGame(gameId: String) {
        db.collection("games").document(gameId).delete() { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
}
