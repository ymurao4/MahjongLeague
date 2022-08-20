import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Player: Codable, Identifiable {
    
    @DocumentID var id: String?
    let name: String
    let participatingLeague: [League]?
    var userId: String?
}
