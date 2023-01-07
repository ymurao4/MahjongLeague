import ComposableArchitecture
import Foundation

struct AddGameFeature:  ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient
    struct State: Equatable {
        var players: [Player] = []
    }

    enum Action {
        case onAppear
        case loadPlayers
        case playerResponse(TaskResult<PlayerResult>)
    }

    struct AddGameCancelId: Hashable {}
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .task {
                    await Action.playerResponse(TaskResult {
                        try await firebaseAPIClient.loadPlayers()
                    })
                }
                .cancellable(id: AddGameCancelId.self)
            case .loadPlayers:
                return .none
            case let .playerResponse(.success(response)):
                state.players = response.players
                return .none
            case .playerResponse(.failure(_)):
                state.players = []
                return .none
            }
        }
    }
}
