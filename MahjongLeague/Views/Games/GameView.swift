//
//  GameView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/07.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameVM = GameViewModel()
    @State private var games: Game?
    @State private var gamePlayers: [GamePlayer] = []
    
    var body: some View {
        
        NavigationView {
            
            
        }
        .navigationTitle("Add game")
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
