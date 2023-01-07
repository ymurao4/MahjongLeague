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
            ZStack(alignment: .bottom) {
                List {
                    Section(header: HStack {
                        Text("メンバー")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Menu {
                            Button("メンバーを追加", action: {  })
                            Button("メンバーを編集", action: {  })
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }) {
                        if viewStore.players.isEmpty {
                            Text("右上の３点リーダーをタップし、メンバーを追加！")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            LazyVGrid(columns: Array(repeating: columns, count: 5)) {
                                ForEach(viewStore.players) { player in
                                    Button {
                                        viewStore.send(.addScore(Record.Score(player: player, score: "25000")))
                                    } label: {
                                        PlayerView(player: player)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    Section(header: Text("ルール").font(.title3).bold()) {
                        Picker("", selection: viewStore.binding(
                            get: \.peopleCount,
                            send: AddGameFeature.Action.peopleCountChanged)
                        ) {
                            Text("四人麻雀")
                                .tag(0)
                            Text("三人麻雀")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Picker("ウマを選択", selection: viewStore.binding(
                            get: \.gameType,
                            send: AddGameFeature.Action.gameTypeChanged)
                        ) {
                            ForEach(GameType.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                    }
                    Section(header: Text("参加者").font(.title3).bold()) {
                        if viewStore.scores.isEmpty {
                            Text("画面上部のメンバーをタップして参加者を追加！")
                                .font(.callout)
                                .foregroundColor(.gray)

                        } else {
                            ForEach(viewStore.scores) { score in
                                HStack(spacing: 16) {
                                    Text(score.player.name)
//                                    TextField("score", text: $gameResult.score)
//                                        .keyboardType(.numberPad)
                                }

//                                    .swipeActions(edge: .trailing) {
//                                        Button {
//                                            gameResults.remove(at: i)
//                                        } label: {
//                                            Image(systemName: "trash")
//                                        }
//                                        .tint(.red)
//                                    }
                            }
                        }
                    }
                }
                Button {
                    
                } label: {
                    Text("記録する")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .bold()
                }
                .background(Color.primary)
                .cornerRadius(4)
                .padding(.horizontal, 16)
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
