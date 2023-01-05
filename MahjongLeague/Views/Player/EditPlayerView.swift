import SwiftUI

struct EditPlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var isUpdatePlayer: Bool = false
    @State private var index: Int?
    
    var body: some View {
        List {
            ForEach(0..<viewModel.playerCellViewModels.count, id: \.self) { i in
                HStack {
                    Text(viewModel.playerCellViewModels[i].player.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.index = i
                    isUpdatePlayer = true
                }
            }
            .onDelete(perform: delete)
        }
        .toolbar {
            EditButton()
        }
        .alert("メンバー名を編集", isPresented: $isUpdatePlayer, actions: {
            if let index {
                TextField("メンバー名を編集", text: $viewModel.playerCellViewModels[index].player.name)
                Button("キャンセル", action: {})
                Button("更新") {
                    viewModel.updatePlayer(player: viewModel.playerCellViewModels[index].player)
                }
            }
        })
    }
    
    func delete(at offsets: IndexSet) {
        if let i = offsets.first {
            viewModel.deletePlayer(playerId: viewModel.playerCellViewModels[i].id)
        }
    }
}
