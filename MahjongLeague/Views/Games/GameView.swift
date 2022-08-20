//
//  GameView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/07.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameVM = GameViewModel()
    
    
    var body: some View {
        
        NavigationView {
            
            NavigationLink(destination: AddGameView(gameVM: gameVM)) {
                Text("add game view")
            }
        }
        .navigationTitle("List")
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
