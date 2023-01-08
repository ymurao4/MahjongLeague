import ComposableArchitecture
import Foundation

enum AddGameError: Error {
    case playerCount
    case totalScore
    case emptyScore
}

struct AddGameFeature: ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient
    struct State: Equatable {
        @BindableState var focusedField: Field?
        var date: Date = Date.now
        var players: [Player] = []
        var playerCount: Int = 4
        var gameType: GameType = .oneThree
        var isHalfGame: Bool = true
        var scores: [Record.Score] = []
        var scoreFields: [String] = []
        var errorType: AddGameError?
        
        enum Field: String, Hashable {
            case score
        }
    }
    
    enum Action: BindableAction, Equatable {
        case onAppear
        case loadPlayers
        case playerResponse(TaskResult<PlayerResult>)
        case submitGame
        case selectDate(Date)
        case playerCountChanged(Int)
        case gameTypeChanged(GameType)
        case isHalfGameChanged(Bool)
        case addScore(Player)
        case removeScore(Int)
        case scoreFieldChanged(Int, String)
        case binding(BindingAction<State>)
        case focusTextField
        case unFocusTextField
    }
    
    struct AddGameCancelId: Hashable {}
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
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
            case .submitGame:
                guard state.playerCount == state.scores.count else {
                    state.errorType = .playerCount
                    return .none
                }
                var game: Game = .init(
                    result: Record(scores: state.scores),
                    isHalfRound: state.isHalfGame,
                    isFourPeople: state.playerCount == 4,
                    gameType: state.gameType.rawValue
                )
                return .none
            case let .selectDate(date):
                state.date = date
                return .none
            case let .playerCountChanged(count):
                state.playerCount = count
                return .none
            case let .gameTypeChanged(gameType):
                state.gameType = gameType
                return .none
            case let .isHalfGameChanged(isHalfGame):
                state.isHalfGame = isHalfGame
                return .none
            case let .addScore(player):
                if state.scores.count < state.playerCount {
                    for addedScore in state.scores {
                        if addedScore.player.id == player.id {
                            return .none
                        }
                    }
                    let score: Record.Score = .init(player: player, point: "25000")
                    state.scores.append(score)
                }
                return .none
            case let .removeScore(i):
                state.scores.remove(at: i)
                return .none
            case let .scoreFieldChanged(i, text):
                state.scores[i].point = text
                return .none
            case .binding:
                return .none
            case .focusTextField:
                state.focusedField = .score
                return .none
            case .unFocusTextField:
                state.focusedField = nil
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
