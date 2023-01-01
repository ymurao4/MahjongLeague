import Foundation
import Combine

class LeagueViewModel: ObservableObject {
    
    @Published var leagueRepository = LeagueRepository()
    @Published var leagueCellViewModels = [LeagueCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        leagueRepository.$league.map { leagues in
            
            leagues.map { league in
                
                return LeagueCellViewModel(league: league)
            }
        }
        .assign(to: \.leagueCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func addLeague(league: League) {
        
        leagueRepository.addLeague(league: league)
    }
}
