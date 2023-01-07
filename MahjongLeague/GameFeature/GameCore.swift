import ComposableArchitecture
import Foundation

private enum APIClientKey: DependencyKey {
    static let liveValue = FirebaseAPIClient.live
}

extension DependencyValues {
    var firebaseAPIClient: FirebaseAPIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}

struct GameFeature: ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient

    struct State: Equatable {
        var shoudOpenAddGame = false
        var games: [GameResult.Game] = []
        var addGameState: AddGameState?
    }

    enum Action {
        case loadGames
        case addGame(AddGameAction)
        case updateGame
        case deleteGame
        case setAddGameView(isPresented: Bool)
        case gameResponse(TaskResult<GameResult>)

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
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadGames:
                return .none
            case .addGame:
                return .none
            case .updateGame:
                return .none
            case .deleteGame:
                return .none
            case .onAppear:
                return .task {
                    await Action.gameResponse(TaskResult { try await firebaseAPIClient.loadGames()} )
                }
                .cancellable(id: GameCancelId.self)
            case .onDisappear:
                return .none
            case let .gameResponse(.success(response)):
                state.games = response.results
                return .none
            case .gameResponse(.failure(_)):
                state.games = []
                return .none
            case .setAddGameView(let isPresented):
                state.shoudOpenAddGame = isPresented
                return .none
            }
        }
        .ifLet(\.addGameState, action: /Action.addGame) {
//            AddGameFeature()
        }
    }
}
