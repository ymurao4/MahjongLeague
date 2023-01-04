import Foundation
import Combine

class GameCellViewModel: ObservableObject, Identifiable {

    @Published var game: Game
    @Published var date: String = ""
    @Published var result: Result

    private var cancellables = Set<AnyCancellable>()
    
    var id: String = ""

    init(game: Game) {
        self.game = game
        self.result = game.result
        
        $game.compactMap { game in
            guard let date = game.createdTime?.dateValue() else { return game.id }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let stringDate = dateFormatter.string(from: date)
            self.date = stringDate

            return game.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $result.compactMap({ result in
            return result.id
        })
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
}
