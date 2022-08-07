//
//  ContentView.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    var body: some View {
        
        NavigationView {
            
            LeagueView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
