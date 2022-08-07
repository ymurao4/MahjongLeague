import Foundation
import Combine

class GameViewModel: ObservableObject {
    
    @Published var gameRepository = GameRepository()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        gameRepository.$game.map { games in


        }
    }
    
    func addGame(game: Game) {
        
        gameRepository.addGame(game: game)
    }
}
