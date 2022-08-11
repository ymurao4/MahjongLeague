//
//  LeagueView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/07.
//

import SwiftUI

struct LeagueView: View {
    
    @StateObject var leagueVM = LeagueViewModel()
    var league: League
    var players: [Player] = []
    var games: [Game] = []
    var gamePlayers: [GamePlayer] = []
    @State private var isSheet: Bool = false
    
    
    init() {
        
        gamePlayers = [
            GamePlayer(name: "MURAO", score: 35000, order: 1),
            GamePlayer(name: "ICHIRYUU", score: 30000, order: 2),
            GamePlayer(name: "KITAMURA", score: 20000, order: 3),
            GamePlayer(name: "TERASAKA", score: 15000, order: 4)
        ]
        
        players = [
            Player(name: "MURAO", participatingLeague: nil),
            Player(name: "ICHIRYUU", participatingLeague: nil),
            Player(name: "KITAMURA", participatingLeague: nil),
            Player(name: "TERASAKA", participatingLeague: nil)
        ]
        
        games = [
            Game(players: gamePlayers)
        ]
        
        league = League(name: "第一回", players: players, gameCount: 1, games: games)
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Button("move to add league view") {
                    
                    self.isSheet.toggle()
                }
            }
            .sheet(isPresented: $isSheet) {
                
                AddLeagueView(leagueVM: leagueVM)
            }
        }
    }
}

struct LeagueView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueView()
    }
}
