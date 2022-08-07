import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class LeagueRepository {
    
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid

    @Published var league: [League] = []
    
    init() {
        loadDate()
    }
    
    func loadDate() {
        
        db.collection("League")
            .addSnapshotListener { querySnapshot, error in
                
                DispatchQueue.main.async {
                    
                    if let querySnapshot = querySnapshot {
                        
                        self.league = querySnapshot.documents.compactMap({ document in
                            
                            do {
                                
                                let x = try document.data(as: League.self)
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
    
    func addLeague(league: League) {
        
        do {
            
            var addLeague = league
            addLeague.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("League").addDocument(from: addLeague)
        } catch {
            
            fatalError("Unable to encode game: \(error)")
        }
    }
}
