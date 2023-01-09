import ComposableArchitecture
import Foundation

struct GameFeature: ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient

    struct State: Equatable {
        var games: [Game] = []
        var optionalAddGameState: AddGameFeature.State?
        var isSheetPresented = false
    }

    enum Action {
        case gameResponse(TaskResult<GameResult>)
        case updateGame
        case deleteGame(String)
        case deleteGameResponse(TaskResult<None>)
        case optionalAddGame(AddGameFeature.Action)
        case setSheet(isPresented: Bool)

        case task
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .optionalAddGame:
                return .none
            case .updateGame:
                return .none
            case let .deleteGame(gameId):
                return .task {
                    await Action.deleteGameResponse(TaskResult { try await firebaseAPIClient.deleteGame(gameId)})
                }
            case let .deleteGameResponse(result):
                switch result {
                case .success:
                    return .none
                case .failure:
                    return .none
                }
            case .task:
                return .run { send in
                    for try await result in try await firebaseAPIClient.loadGames() {
                        await send(.gameResponse(.success(result)))
                    }
                } catch: { error, send in
                    await send(.gameResponse(.failure(error)))
                }
            case let .gameResponse(result):
                switch result {
                case let .success(response):
                    state.games = response.results
                    return .none
                case .failure:
                    state.games = []
                    return .none
                }
            case .setSheet(isPresented: true):
                state.isSheetPresented = true
                state.optionalAddGameState = AddGameFeature.State()
                return .none
            case .setSheet(isPresented: false):
                state.isSheetPresented = false
                state.optionalAddGameState = nil
                return .none
            }
        }
        .ifLet(\.optionalAddGameState, action: /Action.optionalAddGame) {
            AddGameFeature()
        }
    }
}
