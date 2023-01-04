//
//  AddLeagueView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/11.
//

import SwiftUI

struct AddLeagueView: View {
    
    @Environment(\.presentationMode) var presentatinoMode
    @StateObject var leagueVM: LeagueViewModel
//    @State private var 
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                
            }
            .navigationBarItems(
                leading: Button(action: {
                    self.presentatinoMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "lessthan")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.orange)
                })
            )
        }
    }
}
