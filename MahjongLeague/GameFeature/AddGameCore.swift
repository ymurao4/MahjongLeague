import ComposableArchitecture
import Foundation

struct AddGameState: Equatable {
}

enum AddGameAction {
}

struct AddGameEnvironment {
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

typealias AddGameReducer = AnyReducer<GameState, GameAction, GameEnvironment>
let addGameReducer = AddGameReducer { state, action, environment in

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
