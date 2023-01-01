import Foundation
import Combine

class PlayerCellViewModel: ObservableObject, Identifiable {

    @Published var player: Player

    private var cancellables = Set<AnyCancellable>()

    var id: String = ""

    init(player: Player) {

        self.player = player

        $player.compactMap { player in

            player.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
}
