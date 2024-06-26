import SwiftUI

/// Orbit component that displays a control that can be selected, unselected, or removed.
///
/// A ``Tag`` consists of a label, icon and optional removable action.
///
/// ```swift
/// Tag("Sorting", icon: .sort, isSelected: $isSortingApplied)
/// Tag("Filters", style: .removable(action: { /* Tap action */ }), isSelected: $isFiltersApplied)
/// ```
/// 
/// ### Customizing appearance
///
/// The label and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
///
/// ```swift
/// Tag("Selected", isSelected: $isSelected)
///     .textColor(.blueLight)
///     .iconColor(.blueNormal)
/// ```
///
/// Before the action is triggered, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component does not expand horizontally, unless forced by the native ``idealSize()`` modifier with a `false` value.
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/tag/)
public struct Tag<Icon: View>: View, PotentiallyEmptyView {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let label: String
    private let style: TagStyle
    private let isFocused: Bool
    @Binding private var isSelected: Bool
    @ViewBuilder private let icon: Icon

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                isSelected.toggle()
            } label: {
                HStack(spacing: 0) {
                    if idealSize.horizontal == false {
                        Spacer(minLength: 0)
                    }
                    
                    HStack(spacing: 6) {
                        icon
                            .font(.system(size: Text.Size.normal.value))
                        
                        Text(label)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    if idealSize.horizontal == false {
                        Spacer(minLength: 0)
                    }
                }
            }
            .buttonStyle(
                TagButtonStyle(
                    style: style,
                    isFocused: isFocused,
                    isSelected: isSelected
                )
            )
            .accessibility(addTraits: isSelected ? .isSelected : [])
        }
    }

    var isEmpty: Bool {
        label.isEmpty && icon.isEmpty
    }
}

// MARK: - Inits
public extension Tag {

    /// Creates Orbit ``Tag`` component with custom leading icon.
    init(
        _ label: String = "",
        style: TagStyle = .default,
        isFocused: Bool = true,
        isSelected: Binding<Bool>,
        @ViewBuilder icon: () -> Icon
    ) {
        self.label = label
        self.style = style
        self.isFocused = isFocused
        self._isSelected = isSelected
        self.icon = icon()
    }

    /// Creates Orbit ``Tag`` component.
    init(
        _ label: String = "",
        icon: Icon.Symbol? = nil,
        style: TagStyle = .default,
        isFocused: Bool = true,
        isSelected: Binding<Bool>
    ) where Icon == Orbit.Icon {
        self.init(
            label,
            style: style,
            isFocused: isFocused,
            isSelected: isSelected
        ) {
            Icon(icon)
                .iconSize(textSize: .normal)
        }
    }
}

// MARK: - Types

/// Orbit ``Tag`` style.
public enum TagStyle: Equatable {

    case `default`
    case removable(action: () -> Void)

    public static func == (lhs: TagStyle, rhs: TagStyle) -> Bool {
        switch (lhs, rhs) {
            case (.default, .default):      return true
            case (.removable, .removable):  return true
            default:                        return false
        }
    }
}

// MARK: - Previews
struct TagPreviews: PreviewProvider {

    static let label = "Prague"

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneExpanding
            styles
            sizing
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(true) { isSelected in
            Tag(label, icon: .grid, style: .removable(action: {}), isSelected: isSelected)
            Tag("", isSelected: .constant(false)) // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var standaloneExpanding: some View {
        StateWrapper(true) { isSelected in
            Tag(label, icon: .grid, style: .removable(action: {}), isSelected: isSelected)
                .idealSize(horizontal: false)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(alignment: .leading, spacing: .large) {
            stack(style: .default, isFocused: true)
            stack(style: .default, isFocused: false)
            stack(style: .removable(action: {}), isFocused: true)
            stack(style: .removable(action: {}), isFocused: false)
            Separator()
            stack(style: .default, isFocused: false, idealWidth: false)
            stack(style: .removable(action: {}), isFocused: true, idealWidth: false)
            Separator()
            HStack(spacing: .medium) {
                StateWrapper(true) { isSelected in
                    Tag(label, icon: .sort, style: .removable(action: {}), isSelected: isSelected)
                }
                StateWrapper(false) { isSelected in
                    Tag(icon: .notificationAdd, isFocused: false, isSelected: isSelected)
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .trailing, spacing: .large) {
            Group {
                Tag("Tag", isFocused: false, isSelected: .constant(false))
                Tag("Tag", icon: .grid, isFocused: false, isSelected: .constant(false))
                Tag(icon: .grid, isFocused: false, isSelected: .constant(false))
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func stack(style: TagStyle, isFocused: Bool, idealWidth: Bool? = nil) -> some View {
        HStack(spacing: .medium) {
            VStack(spacing: .small) {
                tag(style: style, isFocused: isFocused, isSelected: false)
                tag(style: style, isFocused: isFocused, isSelected: true)
            }
        }
        .idealSize(horizontal: idealWidth)
    }

    static func tag(style: TagStyle, isFocused: Bool, isSelected: Bool) -> some View {
        StateWrapper((style, isSelected, true)) { state in
            Tag(
                label,
                style: style == .default ? .default : .removable(action: { state.wrappedValue.2 = false }),
                isFocused: isFocused,
                isSelected: state.1
            )
            .opacity(state.wrappedValue.2 ? 1 : 0)
        }
    }
}
