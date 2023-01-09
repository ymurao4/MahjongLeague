import SwiftUI
import ComposableArchitecture

struct PopUpView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.primary)
            Text(message)
                .font(.caption)
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
