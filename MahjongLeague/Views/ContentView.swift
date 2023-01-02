import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        
        NavigationStack {
            TabView {
                GameView()
                    .tabItem {
                        Image("mahjong")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("記録")
                            .foregroundColor(.primary)
                    }
                GameView()
                    .tabItem {
                        Text("分析")
                            .foregroundColor(.primary)
                        Image("mahjong")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
            }
        }
        .navigationTitle("麻雀")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
