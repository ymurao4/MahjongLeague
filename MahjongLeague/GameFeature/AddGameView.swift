import SwiftUI
import ComposableArchitecture

struct AddGameView: View {
    let store: StoreOf<AddGameFeature>
    @FocusState var focusedField: AddGameFeature.State.Field?
    @Environment(\.dismiss) var dismiss

    private let columns: GridItem = .init(.fixed(56))
    
    init(store: StoreOf<AddGameFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationStack {
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
                                            viewStore.send(.addScore(player))
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
                                get: \.playerCount,
                                send: AddGameFeature.Action.playerCountChanged)
                            ) {
                                Text("四人麻雀")
                                    .tag(4)
                                Text("三人麻雀")
                                    .tag(3)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            Toggle("半荘", isOn: viewStore.binding(
                                get: \.isHalfGame,
                                send: AddGameFeature.Action.isHalfGameChanged)
                            )
                            DatePicker("日付を選択", selection: viewStore.binding(
                                get: \.date,
                                send: AddGameFeature.Action.selectDate)
                                       , displayedComponents: .date)
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
                                ForEach(0..<viewStore.scores.count, id:\.self) { i in
                                    HStack(spacing: 16) {
                                        Text(viewStore.scores[i].player.name)
                                        TextField("score", text: viewStore.binding(
                                            get: \.scores[i].point,
                                            send: { .scoreFieldChanged(i, $0) })
                                        )
                                        .onTapGesture {
                                            viewStore.send(.focusTextField)
                                        }
                                        .focused($focusedField, equals: .score)
                                        .keyboardType(.numberPad)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            viewStore.send(.removeScore(i))
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .tint(.red)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("記録", displayMode: .inline)
                .toolbar {
                    Button {
                        viewStore.send(.submitGame)
                    } label: {
                        Text("保存")
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .onChange(of: viewStore.state.submitResult) { value in
                    if value {
                        dismiss()
                    }
                }
            }
            .synchronize(viewStore.binding(\.$focusedField), self.$focusedField)
            .gesture(
                DragGesture()
                .onChanged{ value in
                    if value.translation.height != 0 {
                        viewStore.send(.unFocusTextField)
                    }
                }
            )
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
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

extension View {
  func synchronize<Value>(
    _ first: Binding<Value>,
    _ second: FocusState<Value>.Binding
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }
}
