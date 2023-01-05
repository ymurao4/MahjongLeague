import SwiftUI

struct PopUpView: View {
    @Binding var isPopUpView: Bool
    let message: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.primary)
            Text(message)
                .bold()
            Spacer()
            Button {
                isPopUpView = false
            } label: {
                Text("OK")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.primary)
                    .cornerRadius(8)
            }

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary, lineWidth: 4)
        )
        .background(Color.white)
        .cornerRadius(16)
    }
}
