import SwiftUI
import ComposableArchitecture

struct AddGameView: View {
    let store: StoreOf<AddGameFeature>
    private let columns: GridItem = .init(.fixed(56))
    
    init(store: StoreOf<AddGameFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                if viewStore.players.isEmpty {
                    Text("右上の３点リーダーをタップし、メンバーを追加！")
                        .font(.callout)
                        .foregroundColor(.gray)
                } else {
                    LazyVGrid(columns: Array(repeating: columns, count: 5)) {
                        ForEach(viewStore.players) { player in
                            Button {

                            } label: {
                                PlayerView(player: player)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    private struct PlayerView: View {
        var player: Player

        var body: some View {
            Text(player.name)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(height: 20)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
    }
}
