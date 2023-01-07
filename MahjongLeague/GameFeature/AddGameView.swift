import SwiftUI
import ComposableArchitecture

struct AddGameView: View {
    let store: StoreOf<AddGameFeature>
    
    init(store: StoreOf<AddGameFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Text("hoge")
        }
    }
}
