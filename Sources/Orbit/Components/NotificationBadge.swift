import SwiftUI

/// Shows simple, non-interactive information in a circular badge.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/notificationbadge/)
public struct NotificationBadge: View {

    @Environment(\.sizeCategory) var sizeCategory

    let content: Content
    let style: Badge.Style

    public var body: some View {
        if isEmpty == false {
            contentView
                .padding(.xxSmall) // = 24 height @ normal size
                .foregroundColor(Color(style.labelColor))
                .background(
                    style.background
                        .clipShape(shape)
                )
                .overlay(
                    shape
                        .strokeBorder(style.outlineColor, lineWidth: BorderWidth.thin)
                )
                .fixedSize()
        }
    }

    @ViewBuilder var contentView: some View {
        switch content {
            case .text(let text):
                Text(
                    text,
                    size: .small,
                    color: .none,
                    weight: .medium,
                    linkColor: .custom(style.labelColor)
                )
                .frame(minWidth: minTextWidth)
            case .icon(let icon):
                Icon(content: icon, size: .small)
        }
    }

    var minTextWidth: CGFloat {
        Text.Size.small.lineHeight * sizeCategory.ratio
    }

    var shape: some InsettableShape {
        Circle()
    }

    var isEmpty: Bool {
        switch content {
            case .text(let text):   return text.isEmpty
            case .icon(let icon):   return icon.isEmpty
        }
    }
}

// MARK: - Inits
public extension NotificationBadge {
    
    /// Creates Orbit NotificationBadge component containing text.
    init(_ label: String, style: Badge.Style = .neutral) {
        self.init(content: .text(label), style: style)
    }

    /// Creates Orbit NotificationBadge component containing an icon.
    init(_ icon: Icon.Content, style: Badge.Style = .neutral) {
        self.init(content: .icon(icon), style: style)
    }
}

// MARK: - Types
public extension NotificationBadge {

    enum Content {
        case icon(Icon.Content)
        case text(String)
    }
}

// MARK: - Previews
struct NotificationBadgePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            statuses
            gradients
            mix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            NotificationBadge("9")
            NotificationBadge("")  // EmptyView
        }
        .previewDisplayName()
    }

    static var sizing: some View {
        NotificationBadge("88")
            .measured()
        .previewDisplayName()
    }

    static var statuses: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                badges(.light)
                badges(.lightInverted)
            }

            badges(.neutral)

            statusBadges(.info)
            statusBadges(.success)
            statusBadges(.warning)
            statusBadges(.critical)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var gradients: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            gradientBadge(.bundleBasic)
            gradientBadge(.bundleMedium)
            gradientBadge(.bundleTop)
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            HStack(spacing: .small) {
                NotificationBadge(
                    .symbol(.airplane, color: .pink),
                    style: .custom(
                        labelColor: .blueDark,
                        outlineColor: .blueDark,
                        backgroundColor: .whiteNormal
                    )
                )

                NotificationBadge(.countryFlag("us"))
            }

            HStack(spacing: .small) {
                NotificationBadge(.image(.orbit(.facebook)))
                NotificationBadge(.sfSymbol("ant.fill"))
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        statuses
            .padding(.medium)
    }

    static func badges(_ style: Badge.Style) -> some View {
        HStack(spacing: .medium) {
            NotificationBadge(.grid, style: style)
            NotificationBadge("1", style: style)
        }
    }

    static func statusBadges(_ status: Status) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            badges(.status(status))
            badges(.status(status, inverted: true))
        }
        .previewDisplayName("\(String(describing: status).titleCased)")
    }

    static func gradientBadge(_ gradient: Gradient) -> some View {
        badges(.gradient(gradient))
            .previewDisplayName("\(String(describing: gradient).titleCased)")
    }
}
