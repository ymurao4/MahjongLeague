import SwiftUI

struct GameView: View {
    
    @StateObject private var gameViewModel = GameViewModel()
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var isShowAddPlayerView: Bool = false
    @State private var isShowAddGameView: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            List {
                ForEach(gameViewModel.gameCellViewModels) { gameCellViewModel in
                    VStack {
                        HStack {
                            Text(gameCellViewModel.date)
                                .font(.callout)
                            Divider()
                            VStack {
                                HStack {
                                    HStack {
                                        Text(gameCellViewModel.game.result.results[0].player.name)
                                        Text(gameCellViewModel.game.result.results[0].score)
                                    }
                                    HStack {
                                        Text(gameCellViewModel.game.result.results[1].player.name)
                                        Text(gameCellViewModel.game.result.results[1].score)
                                    }
                                }
                                HStack {
                                    HStack {
                                        Text(gameCellViewModel.game.result.results[3].player.name)
                                        Text(gameCellViewModel.game.result.results[3].score)
                                    }
                                    HStack {
                                        Text(gameCellViewModel.game.result.results[4].player.name)
                                        Text(gameCellViewModel.game.result.results[4].score)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Button {
                isShowAddPlayerView.toggle()
            } label: {
                Text("Playerを追加")
            }
            Button {
                isShowAddGameView.toggle()
            } label: {
                Text("Gameを追加")
            }
        }
        .navigationTitle("結果を入力")
        .sheet(isPresented: $isShowAddPlayerView) {
            AddPlayerView(viewModel: playerViewModel)
        }
        .sheet(isPresented: $isShowAddGameView) {
            AddGameView(gameViewModel: gameViewModel, players: playerViewModel.playerCellViewModels)
        }
    }

//    struct GameResultView: View {
//
//        var body: some View {
//            VStack {
//                HStack {
//                    Text(gameCellViewModel.)
//                    VStack {
//
//                    }
//                }
//            }
//        }
//    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
