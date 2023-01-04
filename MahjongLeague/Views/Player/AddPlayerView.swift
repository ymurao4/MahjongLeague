import SwiftUI

struct AddPlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel = PlayerViewModel()
    @State private var name: String = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("名前を入力してください", text: $name)
            Button {
                viewModel.addPlayer(player: .init(name: name))
            } label: {
                Text("Playerを追加")
            }
        }
        .padding()
    }
}

struct AddPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayerView(viewModel: PlayerViewModel())
    }
}
