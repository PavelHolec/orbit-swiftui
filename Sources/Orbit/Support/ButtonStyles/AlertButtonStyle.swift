import SwiftUI

/// Button style for Orbit ``Alert`` component.
public struct AlertButtonStyle: PrimitiveButtonStyle {

    @Environment(\.buttonPriority) private var buttonPriority
    @Environment(\.isSubtle) private var isSubtle
    @Environment(\.status) private var status

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textActiveColor: textActiveColor,
            horizontalPadding: .small,
            verticalPadding: .xSmall, // = 32 height @ normal size
            cornerRadius: BorderRadius.desktop,
            hapticFeedback: resolvedStatus.defaultHapticFeedback
        ) {
            EmptyView()
        } disclosureIcon: {
            EmptyView()
        }
        .textFontWeight(.medium)
        .textSize(.small)
        .textColor(textColor)
        .backgroundStyle(background, active: backgroundActive)
    }

    var textColor: Color {
        switch (resolvedPriority, isSubtle) {
            case (.primary, _):         return .whiteNormal
            case (.secondary, true):    return .inkDark
            case (.secondary, false):   return resolvedStatus.darkColor
        }
    }

    var textActiveColor: Color {
        switch (resolvedPriority, isSubtle) {
            case (.primary, _):         return .whiteNormal
            case (.secondary, true):    return .inkDarkActive
            case (.secondary, false):   return resolvedStatus.darkActiveColor
        }
    }

    var background: Color {
        switch (resolvedPriority, isSubtle) {
            case (.primary, _):         return resolvedStatus.color
            case (.secondary, true):    return .inkDark.opacity(0.1)
            case (.secondary, false):   return resolvedStatus.darkColor.opacity(0.12)
        }
    }

    var backgroundActive: Color {
        switch (resolvedPriority, isSubtle) {
            case (.primary, _):         return resolvedStatus.activeColor
            case (.secondary, true):    return .inkDark.opacity(0.2)
            case (.secondary, false):   return resolvedStatus.darkColor.opacity(0.24)
        }
    }

    var resolvedPriority: ButtonPriority {
        buttonPriority ?? .primary
    }

    var resolvedStatus: Status {
        status ?? .info
    }
    
    /// Create button style for Orbit ``Alert`` component.
    public init() {}
}

// MARK: - Previews
struct AlertButtonStylePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        VStack(alignment: .leading, spacing: .medium) {
            button
                .buttonStyle(AlertButtonStyle())
        }
        .previewDisplayName()
    }
    
    static var button: some View {
        SwiftUI.Button {
            // No action
        } label: {
            Text("AlertButtonStyle")
        }
    }
}
