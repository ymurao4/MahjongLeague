import SwiftUI

enum Field: Int, Hashable {
    case player1, player2, player3, player4
}

struct AddGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var playerViewModel: PlayerViewModel = PlayerViewModel()
    @ObservedObject  var gameViewModel: GameViewModel
    
    @State private var gameResults: [Result.GameResult] = []
    @State private var playerNameTextField: String = ""
    @State private var isSubmitAlert: Bool = false
    @State private var isPlayerDeleteAlert: Bool = false
    @State private var isAddPlayer: Bool = false
    @State private var isEditPlayer: Bool = false
    @State private var isHalfRound: Bool = false
    @State private var selectedNumOfPeople: Int = 0
    @State private var selectedGameType: GameType = .oneThree
    @FocusState private var isFocusTextField: Bool
    
    private let columns: GridItem = .init(.fixed(56))
    var gesture: some Gesture {
        DragGesture()
            .onChanged{ value in
                if value.translation.height != 0 {
                    self.isFocusTextField = false
                }
            }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                Section(header: HStack {
                    Text("メンバー")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Menu {
                        Button("メンバーを追加", action: { isAddPlayer.toggle() })
                        Button("メンバーを編集", action: { isEditPlayer.toggle() })
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }) {
                    if playerViewModel.playerCellViewModels.isEmpty {
                        Text("右上の３点リーダーをタップし、メンバーを追加！")
                            .font(.callout)
                            .foregroundColor(.gray)
                    } else {
                        LazyVGrid(columns: Array(repeating: columns, count: 5)) {
                            ForEach(playerViewModel.playerCellViewModels) { player in
                                Button {
                                    addPlayer(player: player.player)
                                } label: {
                                    PlayerView(player: player.player)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                Section(header: Text("ルール").font(.title3).bold()) {
                        Picker("", selection: $selectedNumOfPeople) {
                            Text("四人麻雀")
                                .tag(0)
                            Text("三人麻雀")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Picker("ウマを選択", selection: $selectedGameType) {
                            ForEach(GameType.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                    }
                Section(header: Text("参加者").font(.title3).bold()) {
                        if gameResults.isEmpty {
                            Text("画面上部のメンバーをタップして参加者を追加！")
                                .font(.callout)
                                .foregroundColor(.gray)
                            
                        } else {
                            ForEach(0..<gameResults.count, id: \.self) { i in
                                ScoreView(gameResult: $gameResults[i])
                                    .focused($isFocusTextField)
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            gameResults.remove(at: i)
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                        }
                    }
            }
            .gesture(gesture)
            
            if !isFocusTextField {
                Button {
                    if gameResults.count >= 3 {
                        submitResult()
                    } else {
                        isSubmitAlert.toggle()
                    }
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
        }
        .navigationDestination(isPresented: $isEditPlayer, destination: { EditPlayerView(viewModel: playerViewModel) })
        .alert(isPresented: $isSubmitAlert) {
            Alert(
                title: Text("内容に不備があります"),
                message: Text("・合計スコアが10万点でない\nもしくは\n・メンバー数に過不足があります")
            )
        }
        .alert("メンバー名を追加", isPresented: $isAddPlayer, actions: {
            TextField("メンバー名を入力", text: $playerNameTextField)
            Button("キャンセル", action: {})
            Button("追加") {
                playerViewModel.addPlayer(player: Player(name: playerNameTextField))
                playerNameTextField = ""
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            isFocusTextField = true
        }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            isFocusTextField = false
        }
    }
    
    private func addPlayer(player: Player) {
        let playerCount = selectedNumOfPeople == 0 ? 4 : 3
        for gameResult in gameResults {
            if gameResult.player.id == player.id {
                return
            }
        }
        if gameResults.count < playerCount {
            let newGameResult: Result.GameResult = .init(player: player, score: "")
            gameResults.append(newGameResult)
        }
    }
    
    private func submitResult() {
        var isNotEmptyScore: Bool = false
        var totalScore: Int = 0
        let totalScoreByGameType = selectedNumOfPeople == 0  ? 100000 : 105000
        
        for gameResult in gameResults {
            let score: String = gameResult.score.trimmingCharacters(in: .whitespaces)
            if !score.isEmpty && Int(score) != nil {
                totalScore += Int(score) ?? 0
                isNotEmptyScore = totalScore == totalScoreByGameType
            } else {
                isNotEmptyScore = false
                break
            }
        }
        
        if isNotEmptyScore {
            let result: Result = .init(results: gameResults)
            gameViewModel.addGame(game: .init(result: result, isHalfRound: isHalfRound, isFourPeople: selectedNumOfPeople == 0 , gameType: selectedGameType.rawValue))
            presentationMode.wrappedValue.dismiss()
        } else {
            isSubmitAlert.toggle()
        }
    }
    
    // NOTE: View
    private struct GamePeopleView: View {
        @Binding var isFourPeople: Bool
        var body: some View {
            HStack {
                Button {
                    isFourPeople = true
                } label: {
                    Text("四人麻雀")
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
                .background(isFourPeople ? Color.primary : .white)
                Button {
                    isFourPeople = false
                } label: {
                    Text("三人麻雀")
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
                .background(!isFourPeople ? Color.primary : .white)
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
    
    private struct ScoreView: View {
        @Binding var gameResult: Result.GameResult

        var body: some View {
            HStack(spacing: 16) {
                Text(gameResult.player.name)
                TextField("score", text: $gameResult.score)
                    .keyboardType(.numberPad)
            }
        }
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView(gameViewModel: GameViewModel())
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
