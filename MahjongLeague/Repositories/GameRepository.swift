import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class GameRepository {
    
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid

    @Published var game: [Game] = []
    
    init() {
        loadDate()
    }
    
    func loadDate() {
        
        db.collection("Player")
            .addSnapshotListener { querySnapshot, error in
                
                DispatchQueue.main.async {
                    
                    if let querySnapshot = querySnapshot {
                        
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
    
    func addGame(game: Game) {
        do {
            var addedGame = game
            addedGame.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("games").addDocument(from: addedGame)
        } catch {
            fatalError()
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
