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
        
        db.collection("Game")
            .whereField("id", in: [1])
            .addSnapshotListener { querySnapshot, error in
                
                DispatchQueue.main.async {
                    
                    if let querySnapshot = querySnapshot {
                        
                        self.game = querySnapshot.documents.compactMap({ document in
                            
                            do {
                                
                                return try document.data(as: Game.self)
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
            
            var addGame = game
            addGame.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("Game").addDocument(from: addGame)
        } catch {
            
            fatalError("Unable to encode game: \(error)")
        }
    }
}