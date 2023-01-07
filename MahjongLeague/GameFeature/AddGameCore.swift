import ComposableArchitecture
import Foundation

struct AddGameFeature:  ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient
    struct State: Equatable {
        var players: [Player] = []
        var peopleCount: Int = 0
        var gameType: GameType = .oneThree
        var scores: [Record.Score] = []
    }

    enum Action {
        case onAppear
        case loadPlayers
        case playerResponse(TaskResult<PlayerResult>)
        case addGame(Game)
        case peopleCountChanged(Int)
        case gameTypeChanged(GameType)
        case addScore(Record.Score)
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
            case let .addGame(game):
                return .none
            case let .peopleCountChanged(count):
                state.peopleCount = count
                return .none
            case let .gameTypeChanged(gameType):
                state.gameType = gameType
                return .none
            case let .addScore(score):
                state.scores.append(score)
                return .none
            }
        }
    }
}
