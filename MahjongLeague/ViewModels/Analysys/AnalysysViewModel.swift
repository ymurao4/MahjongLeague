import Foundation
import Combine

class AnalysysViewModel: ObservableObject {

    @Published var repository = GameRepository()
    @Published var analysysCellViewModels = [AnalysysCellViewModel]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        repository.$game.map { games in
            games.map { game in
                return AnalysysCellViewModel(game: game)
            }
        }
        .assign(to: \.analysysCellViewModels, on: self)
        .store(in: &cancellables)
    }
}
