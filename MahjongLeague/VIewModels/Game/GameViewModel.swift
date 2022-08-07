import Foundation
import Combine

class GameViewModel: ObservableObject {

    @Published var gameRepository = GameRepository()
    @Published var gameCellViewModels = [GameCellViewModel]()

    private var cancellables = Set<AnyCancellable>()

    init() {

        gameRepository.$game.map { games in

            games.map { game in
                
                return GameCellViewModel(game: game)
            }
        }
        .assign(to: \.gameCellViewModels, on: self)
        .store(in: &cancellables)

    }

    func addGame(game: Game) {

        gameRepository.addGame(game: game)
    }
}
