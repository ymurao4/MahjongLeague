import SwiftUI

struct GameView: View {
    
    @StateObject private var gameViewModel = GameViewModel()
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var isShowAddPlayerView: Bool = false
    @State private var isShowAddGameView: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                List {
                    ForEach(gameViewModel.gameCellViewModels) { gameCellViewModel in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(gameCellViewModel.date)
                                    .font(.caption)
                                Divider()
                                VStack(alignment: .leading) {
                                    HStack {
                                        GameResultView(name: gameCellViewModel.game.result.results[0].player.name, score: gameCellViewModel.game.result.results[0].score)
                                        Spacer(minLength: 0)
                                        GameResultView(name: gameCellViewModel.game.result.results[1].player.name, score: gameCellViewModel.game.result.results[1].score)
                                    }
                                    HStack {
                                        GameResultView(name: gameCellViewModel.game.result.results[2].player.name, score: gameCellViewModel.game.result.results[2].score)
                                        Spacer(minLength: 0)
                                        GameResultView(name: gameCellViewModel.game.result.results[3].player.name, score: gameCellViewModel.game.result.results[3].score)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Button {
                isShowAddGameView.toggle()
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
        .navigationTitle("麻雀")
        .sheet(isPresented: $isShowAddPlayerView) {
            AddPlayerView(viewModel: playerViewModel)
        }
        .sheet(isPresented: $isShowAddGameView) {
            AddGameView(gameViewModel: gameViewModel, players: playerViewModel.playerCellViewModels)
        }
    }

    struct GameResultView: View {
        let name: String
        let score: String

        var body: some View {
            HStack {
                Text(name)
                Text(score)
                    .font(.subheadline)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
