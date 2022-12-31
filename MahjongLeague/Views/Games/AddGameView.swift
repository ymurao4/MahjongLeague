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
            }
            
            List(players, id: \.id) { player in
                Text(player.name)
            }
        }
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView(gameVM: GameViewModel())
    }
}
