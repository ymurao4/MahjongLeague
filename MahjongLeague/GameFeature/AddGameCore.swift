import ComposableArchitecture
import Foundation

struct AddGameState: Equatable {
}

enum AddGameAction {
}

struct AddGameEnvironment {
    var apiClilent: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    init(
        apiClient: FirebaseAPIClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.apiClilent = apiClient
        self.mainQueue = mainQueue
    }
}

typealias AddGameReducer = AnyReducer<AddGameState, AddGameAction, AddGameEnvironment>
let addGameReducer = AddGameReducer { state, action, environment in
    struct AddGameCancelId: Hashable {}
}
