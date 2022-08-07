//
//  GameView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/07.
//

import SwiftUI

struct GameView: View {
    
//    @StateObject var gameVM = GameViewModel()
    var players: [GamePlayer] = []
    
    init() {
        
        players = [
            GamePlayer(name: "MURAO", score: 25000),
            GamePlayer(name: "ICHIRYU", score: 25000),
            GamePlayer(name: "KITAMURA", score: 25000),
            GamePlayer(name: "TERASAKA", score: 25000),
        ]
    }
    
    var body: some View {
        
//        Button("HELLO, WORLD", action: {
//            gameVM.addGame(
//                game: Game(id: "1",
//                           players: players,
//                           createdTime: nil,
//                           userId: nil)
//            )
//        })
        Text("hello")
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
