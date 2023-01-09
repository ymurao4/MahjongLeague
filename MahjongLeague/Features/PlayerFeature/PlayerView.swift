import SwiftUI
import ComposableArchitecture

struct PlayersView: View {
    let store: StoreOf<PlayerFeature>

    init(store: StoreOf<PlayerFeature>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) {
                List {
                    Section {
                        if viewStore.isTextFieldPresented {
                            HStack {
                                TextField("メンバー名を入力", text: viewStore.binding(
                                    get: \.textField,
                                    send: PlayerFeature.Action.textFieldChanged)
                                )
                                Button {
                                    viewStore.send(.submitPlayer)
                                } label: {
                                    Text("追加")
                                        .font(.callout)
                                        .bold()
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 12)
                                        .foregroundColor(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .background(Color.primary)
                                .cornerRadius(4)
                            }
                        }
                    }
                    Section {
                        ForEach(0..<viewStore.players.count, id:\.self) { i in
                            HStack {
                                Text(viewStore.players[i].name)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .swipeActions {
                                Button {
                                    if let id = viewStore.players[i].id {
                                        viewStore.send(.deletePlayer(id))
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                
                if viewStore.isPopupPresented {
                    PopUpView(message: viewStore.popupMessage)
                        .padding(.horizontal, 16)
                }
            }
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
            .navigationTitle("メンバー一覧")
            .toolbar {
                Button {
                    viewStore.send(.setTextField(isPresented: true))
                } label: {
                    Image(systemName: "plus")
                }
            }
            .task {
                viewStore.send(.task)
            }
        }
    }
}
