import SwiftUI

struct EditPlayerView: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    var body: some View {
        List {
            ForEach(playerViewModel.playerCellViewModels) { playerCellViewModel in
                Text(playerCellViewModel.player.name)
            }
            .onDelete(perform: delete)
        }
        .toolbar {
            EditButton()
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let i = offsets.first {
            playerViewModel.deletePlayer(playerId: playerViewModel.playerCellViewModels[i].id)
        }
    }
}
