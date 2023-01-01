import Foundation
import Combine

class LeagueCellViewModel: ObservableObject, Identifiable {
    
    @Published var league: League
    private var cancellables = Set<AnyCancellable>()
    
    var id: String = ""
    
    init(league: League) {
        
        self.league = league
        
        $league.compactMap { league in
            
            league.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
}
