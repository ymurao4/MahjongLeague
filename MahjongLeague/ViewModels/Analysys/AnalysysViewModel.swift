import Foundation
import Combine

class AnalysysViewModel: ObservableObject {

    @Published var repository = GameRepository()
    @Published var gameCellViewModels = [AnalysysCellViewModel]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        
    }
}
