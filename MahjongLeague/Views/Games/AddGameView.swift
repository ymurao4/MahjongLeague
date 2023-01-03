import SwiftUI

struct AddGameView: View {
    @StateObject private var playerViewModel: PlayerViewModel = PlayerViewModel()
    @ObservedObject  var gameViewModel: GameViewModel
    
    @State private var gameResults: [Result.GameResult] = []
    @State private var playerNameTextField: String = ""
    @State private var isAlert: Bool = false
    @State private var isPopUpView: Bool = false
    @State private var isAddPlayer: Bool = false
    @State private var isHalfRound: Bool = false
    @State private var isFourPeople: Bool = true
    @State private var selectedGameType: GameType = .oneThree
    
    private let columns: GridItem = .init(.flexible(minimum: 60, maximum: 80))
    
    var body: some View {
        ZStack {
            VStack {
                LazyVGrid(columns: Array(repeating: columns, count: 5)) {
                    ForEach(playerViewModel.playerCellViewModels) { player in
                        Button {
                            addPlayer(player: player.player)
                        } label: {
                            PlayerView(player: player.player)
                        }
                    }
                }
                
                List {
                    Section {
                        Toggle("四麻", isOn: $isFourPeople)
                        Picker("ウマを選択", selection: $selectedGameType) {
                            ForEach(GameType.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                    }
                    if !gameResults.isEmpty {
                        Section(header: Text("プレイヤー")) {
                            ForEach(0..<gameResults.count, id: \.self) { i in
                                ScoreView(gameResult: $gameResults[i])
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
                
                VStack {
                    if isPopUpView {
                        PopUpView(isPopUpView: $isPopUpView, message: "正常に記録が完了しました！")
                    }
                    Button {
                        if gameResults.count >= 3 {
                            submitResult()
                        } else {
                            isAlert.toggle()
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
                }
            }
        }
        .padding(16)
        .alert(isPresented: $isAlert) {
            Alert(
                title: Text("内容に不備があります"),
                message: Text("・合計スコアが10万点でない\nもしくは\n・メンバー数が足りていない")
            )
        }
        .alert("プレイヤー名を入力", isPresented: $isAddPlayer, actions: {
            TextField("プレイヤー名を入力", text: $playerNameTextField)
            Button("キャンセル", action: {})
            Button("追加") {
                playerViewModel.addPlayer(player: Player(name: playerNameTextField))
            }
        })
        .navigationBarItems(trailing:
                                Button(action: {
            isAddPlayer.toggle()
        }, label: {
            Image(systemName: "plus")
        })
        )
    }
    
    private func addPlayer(player: Player) {
        let playerCount = isFourPeople ? 4 : 3
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
        let totalScoreByGameType = isFourPeople ? 100000 : 105000
        
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
            gameViewModel.addGame(game: .init(result: result, isHalfRound: isHalfRound, isFourPeople: isFourPeople, gameType: selectedGameType.rawValue))
            
            withAnimation {
                isPopUpView.toggle()
            }
        } else {
            isAlert.toggle()
        }
    }
    
    private struct PlayerView: View {
        var player: Player
        
        var body: some View {
            Text(player.name)
                .foregroundColor(.primary)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
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
            }
        }
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView(gameViewModel: GameViewModel())
    }
}
