import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    @State private var isShowAddPlayerView: Bool = false
    @State private var isShowAddGameView: Bool = false
    private let columns: GridItem = .init(.flexible(minimum: 100, maximum: 120))
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 8) {
                    List {
                        ForEach(viewModel.gameCellViewModels) { gameCellViewModel in
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(spacing: 8) {
                                        Text(gameCellViewModel.date)
                                            .font(.caption)
                                            .lineLimit(1)
                                        HStack(spacing: 4) {
                                            Text(gameCellViewModel.game.isFourPeople ? "四麻" : "三麻")
                                                .font(.caption)
                                            HStack(spacing: 4) {
                                                Text("ウマ:")
                                                    .font(.caption)
                                                Text(gameCellViewModel.game.gameType)
                                                    .font(.caption)
                                            }
                                        }
                                        .foregroundColor(.gray)
                                    }
                                    Divider()
                                    LazyVGrid(columns: Array(repeating: columns, count: 2)) {
                                        ForEach(0..<gameCellViewModel.result.results.count, id: \.self) { i in
                                            HStack {
                                                Text(gameCellViewModel.result.results[i].player.name)
                                                    .font(.footnote)
                                                Text(gameCellViewModel.result.results[i].score)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: delete)
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
            .sheet(isPresented: $isShowAddGameView) {
                NavigationStack {
                    AddGameView(gameViewModel: viewModel)
                        .navigationBarTitle("対戦結果を入力", displayMode: .inline)
                }
            }
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
    
    private func delete(at offsets: IndexSet) {
        if let i = offsets.first {
            viewModel.deleteGame(gameId: viewModel.gameCellViewModels[i].id)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
