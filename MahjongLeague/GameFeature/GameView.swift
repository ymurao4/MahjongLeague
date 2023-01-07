import SwiftUI
import ComposableArchitecture

struct GameView: View {
    let store: StoreOf<GameFeature>
    private let columns: GridItem = .init(.flexible(minimum: 100, maximum: 120))
    
    init(store: StoreOf<GameFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    VStack {
                        if viewStore.games.isEmpty {
                            Text("右下の+から記録しよう！")
                                .foregroundColor(.gray)
                        } else {
                            List {
                                ForEach(viewStore.state.games) { game in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            VStack(spacing: 8) {
                                                //Text(game.date)
                                                //  .font(.caption)
                                                //  .lineLimit(1)
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
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Button {
                        viewStore.send(.setSheet(isPresented: true))
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 60)
                    .background(Color.primary)
                    .cornerRadius(30)
                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.isSheetPresented,
                        send: GameFeature.Action.setSheet(isPresented:)
                    )
                ) {
                    IfLetStore(
                        self.store.scope(
                            state: \.optionalAddGameState,
                            action: GameFeature.Action.optionalAddGame
                        )
                    ) {
                        AddGameView(store: $0)
                    }
                }
                .navigationTitle("麻雀")
                .task {
                    viewStore.send(.task)
                }
            }
        }
    }
}
