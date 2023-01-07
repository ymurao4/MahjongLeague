import ComposableArchitecture
import Foundation

struct AddGameFeature:  ReducerProtocol {
    struct State: Equatable {
    }

    enum Action {
    }
    struct AddGameCancelId: Hashable {}
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {

            }
        }
    }
}
