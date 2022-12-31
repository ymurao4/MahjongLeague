//
//  GameView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/07.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    @State private var gamePlayers: [[String]] = [["", ""], ["", ""], ["", ""], ["", ""], ["", ""]]
    @State private var isHalfRound: Bool = true

    let result: Result = .init(results: ["村尾": "33300", "北村": "24800", "寺坂": "26500","一柳": "15400"])
    
    var body: some View {
        List {
            Toggle("半荘", isOn: $isHalfRound)
            ForEach(0..<4, id: \.self) { i in
                AddGameCell(name: $gamePlayers[i][0], score: $gamePlayers[i][1])
            }
        }
        .navigationTitle("結果を入力")
    }
    
    struct AddGameCell: View {
        @Binding var name: String
        @Binding var score: String
        var body: some View {
            HStack {
                TextField("名前", text: $name)
                Divider()
                TextField("スコア", text: $score)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
