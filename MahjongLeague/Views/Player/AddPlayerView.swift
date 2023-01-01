import SwiftUI

struct AddPlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var name: String = ""
    //    let result: Result = .init(results: ["村尾": "33300", "北村": "24800", "寺坂": "26500","一柳": "15400"])

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
