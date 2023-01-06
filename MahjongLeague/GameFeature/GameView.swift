import SwiftUI
import ComposableArchitecture

struct GameView: View {
    let store: Store<GameState, GameAction>
    private let columns: GridItem = .init(.flexible(minimum: 100, maximum: 120))
    
    init(store: Store<GameState, GameAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEach(viewStore.state.games) { game in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(spacing: 8) {
//                                Text(game.date)
//                                    .font(.caption)
//                                    .lineLimit(1)
                                HStack(spacing: 4) {
                                    Text(game.isFourPeople ? "四麻" : "三麻")
                                        .font(.caption)
                                    HStack(spacing: 4) {
                                        Text("ウマ:")
                                            .font(.caption)
                                        Text(game.gameType)
                                            .font(.caption)
                                    }
                                }
                                .foregroundColor(.gray)
                            }
                            Divider()
                            LazyVGrid(columns: Array(repeating: columns, count: 2), alignment: .leading) {
                                ForEach(0..<game.result.results.count, id: \.self) { i in
                                    HStack {
                                        Text(game.result.results[i].player.name)
                                            .font(.footnote)
                                        Text(game.result.results[i].score)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
