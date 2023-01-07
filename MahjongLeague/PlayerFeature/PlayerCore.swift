import ComposableArchitecture
import Foundation

struct PlayerFeature: ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient

    struct State: Equatable {
        var player: Player
    }

    enum Action: Equatable {
        case addPlayer
    }

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {

        case .addPlayer:
            return .none
        }
    }
}
