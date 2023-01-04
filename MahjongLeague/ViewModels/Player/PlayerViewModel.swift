import Foundation
import Combine

class PlayerViewModel: ObservableObject {
    @Published var repository = PlayerRepository()
    @Published var playerCellViewModels = [PlayerCellViewModel]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        repository.$player.map { players in
            players.map { player in
                return PlayerCellViewModel(player: player)
            }
        }
        .assign(to: \.playerCellViewModels, on: self)
        .store(in: &cancellables)
    }

    func addPlayer(player: Player) {
        repository.addPlayer(player: player)
    }
}