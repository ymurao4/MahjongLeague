import ComposableArchitecture
import Foundation

struct PlayerFeature: ReducerProtocol {
    @Dependency(\.firebaseAPIClient) private var firebaseAPIClient

    struct State: Equatable {
        var players: [Player] = []
        @BindableState var textField: String = ""
        var isTextFieldPresented = false
        var alert: AlertState<Action>?
        var isPopupPresented = false
        var popupMessage = ""
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case task
        case playerResponse(TaskResult<PlayerResult>)
        case submitPlayer
        case submitPlayerResponse(TaskResult<None>)
        case deletePlayer(String)
        case deletePlayerResponse(TaskResult<None>)
        case setTextField(isPresented: Bool)
        case textFieldChanged(String)
        case alertDismissed
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding:
            return .none
        case .task:
            return .run { send in
                for try await result in try await firebaseAPIClient.loadPlayers() {
                    await send(.playerResponse(.success(result)))
                }
            } catch: { error, send in
                await send(.playerResponse(.failure(error)))
            }
        case let .playerResponse(result):
            switch result {
            case let .success(response):
                state.players = response.players
                return .none
            case .failure:
                return .none
            }
        case .submitPlayer:
            if state.textField.trimmingCharacters(in: .whitespaces).isEmpty {
                state.alert = AlertState {
                    TextState("メンバー名が空欄です")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("OK")
                    }
                }
                return .none
            }
            let player: Player = .init(name: state.textField)
            return .task {
                await Action.submitPlayerResponse(TaskResult {
                    try await firebaseAPIClient.submitPlayer(player)
                })
            }
        case let .submitPlayerResponse(result):
            switch result {
            case .success:
                state.textField = ""
                state.isTextFieldPresented = false
                state.popupMessage = "メンバーが正常に登録されました。"
                state.isPopupPresented = true
                return .none
            case .failure:
                return .none
            }
        case let .deletePlayer(playerId):
            return .task {
                await Action.deletePlayerResponse(TaskResult {try await
                    firebaseAPIClient.deletePlayer(playerId)
                })
            }
        case let .deletePlayerResponse(result):
            switch result {
            case .success:
                return .none
            case .failure:
                return .none
            }
        case let .setTextField(isPresented: isPresented):
            switch isPresented {
            case true:
                state.isTextFieldPresented = true
            case false:
                state.isTextFieldPresented = false
            }
            return .none
        case let .textFieldChanged(text):
            state.textField = text
            return .none
        case .alertDismissed:
            state.alert = nil
            return .none
        }
    }
}
