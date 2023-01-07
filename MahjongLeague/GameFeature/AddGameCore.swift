import ComposableArchitecture
import Foundation

struct AddGameFeature: ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient
    struct State: Equatable {
        var players: [Player] = []
        var peopleCount: Int = 4
        var gameType: GameType = .oneThree
        var scores: [Record.Score] = []
        var scoreFields: [String] = []
    }

    enum Action {
        case onAppear
        case loadPlayers
        case playerResponse(TaskResult<PlayerResult>)
        case addGame(Game)
        case peopleCountChanged(Int)
        case gameTypeChanged(GameType)
        case addScore(Player)
        case addScoreField(Int, String)
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
            case let .addScore(player):
                if state.scores.count < state.peopleCount {
                    for addedScore in state.scores {
                        if addedScore.player.id == player.id {
                            return .none
                        }
                    }
                    let score: Record.Score = .init(player: player, point: "25000")
                    state.scores.append(score)
                }
                return .none
            case let .addScoreField(i, text):
                state.scores[i].point = text
                return .none
            }
        }
    }
}


struct ScoreFeature: ReducerProtocol {
    struct State: Equatable {
        var player: Player
        var point: String
    }
    
    enum Action {
        case addScore(Record.Score)
        case scoreChanged(String)
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case let .addScore(score):
            state.player = score.player
            state.point = score.point
            return .none
        case let .scoreChanged(point):
            state.point = point
            return .none
        }
    }
}
