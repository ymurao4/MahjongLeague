//
//  MahjongLeagueApp.swift
//  MahjongLeague
//
//  Created by 村尾慶伸 on 2022/08/06.
//

import SwiftUI

@main
struct MahjongLeagueApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
