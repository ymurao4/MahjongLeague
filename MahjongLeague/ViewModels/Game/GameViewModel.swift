import Foundation
import Combine

class GameViewModel: ObservableObject {

    @Published var repository = GameRepository()
    @Published var gameCellViewModels = [GameCellViewModel]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        repository.$game.map { games in
            games.map { game in
                return GameCellViewModel(game: game)
            }
        }
        .assign(to: \.gameCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func reloadData() {
        repository.loadDate()
    }

    func addGame(game: Game) {
        repository.addGame(game: game)
    }
    
    func deleteGame(gameId: String?) {
        if let gameId = gameId {
            repository.deleteGame(gameId: gameId)
        }
    }
}
