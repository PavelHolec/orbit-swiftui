import SwiftUI

struct OrbitCustomButtonContent<LeadingIcon: View, TrailingIcon: View, Background: View, BackgroundActive: View>: View {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.idealSize) private var idealSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor
    @Environment(\.textLinkColor) private var textLinkColor
    @State private var isPressed = false
    
    let configuration: PrimitiveButtonStyleConfiguration
    var textActiveColor: Color? = nil
    var horizontalPadding: CGFloat = .small
    var horizontalLabelPadding: CGFloat = .xxSmall
    var verticalPadding: CGFloat = .small
    var horizontalBackgroundPadding: CGFloat = 0
    var verticalBackgroundPadding: CGFloat = 0
    var cornerRadius: CGFloat = BorderRadius.default
    var spacing: CGFloat = .xxSmall
    var isTrailingIconSeparated = false
    var hapticFeedback: HapticsProvider.HapticFeedbackType = .light()
    @ViewBuilder let icon: LeadingIcon
    @ViewBuilder let disclosureIcon: TrailingIcon
    @ViewBuilder let background: Background
    @ViewBuilder let backgroundActive: BackgroundActive

    var body: some View {
        HStack(spacing: 0) {
            // Maintain height to allow button with no content
            TextStrut()

            if shouldExpand {
                Spacer(minLength: 0)
            }

            HStack(spacing: spacing) {
                icon
                label
                    .padding(.horizontal, horizontalLabelPadding)
                    .layoutPriority(1)
                disclosureIcon
                    .frame(maxWidth: disclosureIconMaxWidth, alignment: .trailing)
            }

            if shouldExpand {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalBackgroundPadding)
        .padding(.vertical, verticalBackgroundPadding)
        .background(
            backgroundView
        )
        .cornerRadius(cornerRadius)
        // This workaround can be replaced with `containerRelativeFrame` in iOS17
        .padding(.horizontal, -horizontalBackgroundPadding)
        .padding(.vertical, -verticalBackgroundPadding)
        .textColor(isPressed ? textActiveColor ?? textColor : textColor)
        .foregroundColor(isPressed ? textActiveColor ?? textColor : textColor)
        .contentShape(Rectangle())
        ._onButtonGesture { isPressed in
            self.isPressed = isPressed
        } perform: {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(hapticFeedback)
            }

            configuration.trigger()
        }
    }

    @ViewBuilder var label: some View {
        if #available(iOS 14, *) {
            configuration.label
        } else {
            configuration.label
                // Prevents text value animation issue due to different iOS13 behavior
                .animation(nil)
        }
    }

    @ViewBuilder var backgroundView: some View {
        if isPressed {
            backgroundActive
        } else {
            background
        }
    }

    var shouldExpand: Bool {
        idealSize.horizontal != true && isTrailingIconSeparated == false
    }

    var disclosureIconMaxWidth: CGFloat? {
        idealSize.horizontal != true && isTrailingIconSeparated
            ? .infinity
            : nil
    }
}

// MARK: ButtonStyle

struct OrbitCustomButtonStyle<LeadingIcon: View, TrailingIcon: View, Background: View, BackgroundActive: View>: PrimitiveButtonStyle {

    var textActiveColor: Color? = nil
    var horizontalPadding: CGFloat = .medium
    var horizontalLabelPadding: CGFloat = .xxSmall
    var verticalPadding: CGFloat = .small
    var horizontalBackgroundPadding: CGFloat = 0
    var verticalBackgroundPadding: CGFloat = 0
    var cornerRadius: CGFloat = BorderRadius.default
    var spacing: CGFloat = .xxSmall
    var isTrailingIconSeparated = false
    var hapticFeedback: HapticsProvider.HapticFeedbackType = .light()
    @ViewBuilder let icon: LeadingIcon
    @ViewBuilder let disclosureIcon: TrailingIcon
    @ViewBuilder let background: Background
    @ViewBuilder let backgroundActive: BackgroundActive

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textActiveColor: textActiveColor,
            horizontalPadding: horizontalPadding,
            horizontalLabelPadding: horizontalLabelPadding,
            verticalPadding: verticalPadding,
            horizontalBackgroundPadding: horizontalBackgroundPadding,
            verticalBackgroundPadding: verticalBackgroundPadding,
            cornerRadius: cornerRadius,
            spacing: spacing,
            isTrailingIconSeparated: isTrailingIconSeparated,
            hapticFeedback: hapticFeedback
        ) {
            icon
        } disclosureIcon: {
            disclosureIcon
        } background: {
            background
        } backgroundActive: {
            backgroundActive
        }
    }
}

// MARK: Previews
struct OrbitCustomButtonContentPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            idealSize
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(false) { isPressed in
            VStack(spacing: .medium) {
                SwiftUI.Button {
                    // No action
                } label: {
                    Text("Label")
                }
                .buttonStyle(PreviewButtonStyle())
                .border(Color.redNormal, width: .hairline)
            }
        }
        .measured()
        .previewDisplayName()
    }

    static var idealSize: some View {
        StateWrapper(false) { isPressed in
            VStack(spacing: .medium) {
                SwiftUI.Button {
                    // No action
                } label: {
                    Text("Label")
                }
                .buttonStyle(PreviewButtonStyle())
                .border(Color.redNormal, width: .hairline)
            }
        }
        .idealSize()
        .measured()
        .previewDisplayName()
    }

    private struct PreviewButtonStyle: PrimitiveButtonStyle {

        public func makeBody(configuration: Configuration) -> some View {
            OrbitCustomButtonContent(
                configuration: configuration,
                textActiveColor: .redDark,
                horizontalPadding: .xSmall,
                verticalPadding: .xxSmall,
                horizontalBackgroundPadding: .small,
                verticalBackgroundPadding: .xSmall,
                cornerRadius: BorderRadius.default,
                spacing: .medium,
                isTrailingIconSeparated: true
            ) {
                Icon(.grid)
            } disclosureIcon: {
                Icon(.chevronForward)
            } background: {
                Color.orangeLight
            } backgroundActive: {
                Color.greenLight
            }
            .textColor(.blueDark)
        }
    }
}