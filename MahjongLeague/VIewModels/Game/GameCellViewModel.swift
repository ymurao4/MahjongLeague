import Foundation
import Combine

class GameCellViewModel: ObservableObject, Identifiable {

    @Published var game: Game

    private var cancellables = Set<AnyCancellable>()
    
    var id: String = ""

    init(game: Game) {

        self.game = game

        $game.compactMap { game in

            game.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
}
