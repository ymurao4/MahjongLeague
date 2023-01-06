import ComposableArchitecture
import Foundation

struct GameState: Equatable {
    var shoudOpenAddGame = false
    var games: [GameResult.Game] = []
    var addGameState: AddGameState?
}

enum GameAction {
    case loadGames
    case addGame(AddGameAction)
    case updateGame
    case deleteGame
    case setAddGameView(isPresented: Bool)
    case gameResponse(TaskResult<GameResult>)
    
    case onAppear
    case onDisappear
}

struct GameEnvironment {
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

typealias GameReducer = AnyReducer<GameState, GameAction, GameEnvironment>

let gameReducer = GameReducer.combine(
    
    addGameReducer
        .optional()
        .pullback(
            state: \.addGameState,
            action: /GameAction.addGame,
            environment: { _ in AddGameEnvironment(
                apiClient: FirebaseAPIClient.live,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()) }
        ),
    .init { state, action, environment in
        struct GameCancelId: Hashable {}
        
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
                await GameAction.gameResponse(TaskResult { try await environment.apiClilent.loadGames()} )
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
)
