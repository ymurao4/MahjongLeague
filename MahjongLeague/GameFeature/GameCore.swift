import ComposableArchitecture
import Foundation

struct GameFeature: ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient

    struct State: Equatable {
        var games: [GameResult.Game] = []
        var optionalAddGameState: AddGameFeature.State?
        var isSheetPresented = false
    }

    enum Action {
        case loadGames
        case updateGame
        case deleteGame
        case optionalAddGame(AddGameFeature.Action)
        case setSheet(isPresented: Bool)
        case gameResponse(TaskResult<GameResult>)

        case task
        case onAppear
        case onDisappear
    }

    struct Environment {
        var apiClient: FirebaseAPIClient
        var mainQueue: AnySchedulerOf<DispatchQueue>

        init(
            apiClient: FirebaseAPIClient,
            mainQueue: AnySchedulerOf<DispatchQueue>
        ) {
            self.apiClient = apiClient
            self.mainQueue = mainQueue
        }
    }

    struct GameCancelId: Hashable {}
    struct SheetCancelID {}
    struct CancelID {}
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadGames:
                return .none
            case .optionalAddGame:
                return .none
            case .updateGame:
                return .none
            case .deleteGame:
                return .none
            case .task:
                return .task {
                    await Action.gameResponse(TaskResult { try await firebaseAPIClient.loadGames()} )
                }
                .cancellable(id: GameCancelId.self)
            case .onAppear:
                return .none
            case .onDisappear:
                return .none
            case let .gameResponse(.success(response)):
                state.games = response.results
                return .none
            case .gameResponse(.failure(_)):
                state.games = []
                return .none
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
