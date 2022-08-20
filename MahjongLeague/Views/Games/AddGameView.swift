//
//  AddGameView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/11.
//

import SwiftUI

struct AddGameView: View {
    
    @ObservedObject  var gameVM: GameViewModel
    @State private var players: [Player] = []
    @State private var playerNameTextField: String = ""
    @State var num: Int = 0
    
    var body: some View {
        
        VStack {
            
            Form {
                
                TextField("Input player name", text: $playerNameTextField)
                
                Button {
                    self.players.append(Player(id: String(num), name: playerNameTextField, participatingLeague: nil))
                    playerNameTextField = ""
                    num += 1
                } label: {
                    Text("add text")
                }
            }
            
            List(players, id: \.id) { player in
                Text(player.name)
            }
        }
    }
}
