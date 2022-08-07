//
//  LeagueView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/07.
//

import SwiftUI

struct LeagueView: View {
    
    @StateObject var leagueVM = LeagueViewModel()
    var leagues: [League] = []
    var players: [Player] = []
    

    init() {
        
        players = [
            Player(name: "MURAO", participatingLeague: nil),
            Player(name: "ICHIRYUU", participatingLeague: nil),
            Player(name: "KITAMURA", participatingLeague: nil),
            Player(name: "TERASAKA", participatingLeague: nil)
        ]
        
        leagues = [
            League(name: "1", players: players, gameCount: 1),
            League(name: "2", players: players, gameCount: 1),
            League(name: "3", players: players, gameCount: 1)
        ]
        
        
    }
    
    var body: some View {
        
        VStack {
            
            List {
                
                ForEach(leagueVM.leagueCellViewModels) { leagueCellVM in
                    
                    HStack {
                            
                        
                    }
                }
            }
        }
    }
}

struct LeagueView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueView()
    }
}
