import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Player: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    var userId: String?
}
