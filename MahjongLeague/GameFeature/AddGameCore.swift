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
        var alert: AlertState<Action>?
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
        case submitGameResponse(TaskResult<None>)
        
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
        case alertDismissed
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
                let message = validateScore()
                
                if state.errorType != nil {
                    state.alert = AlertState {
                        TextState("Alert!")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("Cancel")
                        }
                    } message: {
                        TextState(message)
                    }
                    return .none
                }
                
                let game: Game = .init(
                    date: state.date,
                    result: Record(scores: state.scores),
                    isHalfRound: state.isHalfGame,
                    isFourPeople: state.playerCount == 4,
                    gameType: state.gameType.rawValue
                )
                return .task {
                    await Action.submitGameResponse(TaskResult {
                        try await firebaseAPIClient.submitGame(game)
                    })
                }
            case .submitGameResponse(.success):
                return .none
            case .submitGameResponse(.failure):
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
            case .alertDismissed:
                state.alert = nil
                return .none
            }
            
            func validateScore() -> String {
                state.errorType = nil
                
                var totalScore: Int = 0
                let expectedTotalScore = state.playerCount == 4 ? 100000 : 105000
                
                for score in state.scores {
                    let point = score.point.trimmingCharacters(in: .whitespaces)
                    if point.isEmpty || Int(point) == nil {
                        state.errorType = .emptyScore
                    }
                    totalScore += Int(score.point) ?? 0
                }
                
                if state.playerCount != state.scores.count {
                    state.errorType = .playerCount
                } else if totalScore != expectedTotalScore {
                    state.errorType = .totalScore
                }
                
                var message: String
                switch state.errorType {
                case .playerCount:
                    message = "人数に過不足があります"
                case .totalScore:
                    let diff = expectedTotalScore - totalScore
                    message = "合計点に過不足があります\(diff)"
                case .emptyScore:
                    message = "点数欄に空文字もしくは数字以外が入力されています"
                case .none:
                    message = ""
                }
                return message
            }
        }
    }
}
