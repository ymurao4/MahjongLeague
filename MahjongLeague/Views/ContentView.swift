import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    var body: some View {
        
        NavigationStack {
            GameView()
        }
        .navigationTitle("麻雀")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
