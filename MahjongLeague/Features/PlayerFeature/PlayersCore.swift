//import ComposableArchitecture
//
//struct PlayersFeature: ReducerProtocol {
//    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient
//    
//    struct State: Equatable {
//        var players: [Player] = []
//    }
//    
//    enum Action: Equatable {
//        case delegate(DelegateAction)
//        case loadPlayers(TaskResult<PlayerResult>)
//        case playerResponse(TaskResult<PlayerResult>)
//    }
//    
//    enum DelegateAction: Equatable {
//        case loadPlayers(TaskResult<PlayerResult>)
//    }
//    
//    struct CanncellID: Hashable {}
//    var body: some ReducerProtocol<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .delegate:
//                return .none
//            case .loadPlayers:
//                return .task {
//                    await Action.playerResponse(TaskResult {
//                        try await firebaseAPIClient.loadPlayers()
//                    })
//                }
//                .cancellable(id: CanncellID.self)
//            case let .playerResponse(result):
//                switch result {
//                case let .success(response):
//                    state.players = response.players
//                    return .none
//                case .failure:
//                    state.players = []
//                    return .none
//                }
//            }
//        }
//    }
//}
