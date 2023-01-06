import SwiftUI
import ComposableArchitecture

struct AddGameView: View {
    let store: Store<AddGameState, AddGameAction>
    
    init(store: Store<AddGameState, AddGameAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Text("hoge")
        }
    }
}
