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

    @State private var isSheet: Bool = false

    
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
