import SwiftUI

extension PreviewProvider {

    @ViewBuilder static var headerPlaceholder: some View {
        Text("Custom\nheader content")
            .padding(.vertical, .medium)
            .frame(maxWidth: .infinity)
            .background(Color.blueLightActive)
    }
    
    @ViewBuilder static var contentPlaceholder: some View {
        Color.productLightActive.opacity(0.3)
            .frame(height: 80)
            .overlay(Text("Custom content", color: .inkNormal))
    }

    @ViewBuilder static var intrinsicContentPlaceholder: some View {
        Text("Intrinsic content", color: .inkNormal)
            .padding(.medium)
            .background(Color.productLightActive.opacity(0.3))
    }
}
