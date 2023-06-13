import SwiftUI

// Modifiers that shadow the SwiftUI modifiers need to have the exact signature
// in order to prefer the method of the Text over the generic View version

protocol TextBuildable {

    var baselineOffset: CGFloat? { get set }
    var fontWeight: Font.Weight? { get set }
    var color: Color? { get set }
}

protocol FormattedTextBuildable: TextBuildable {

    var accentColor: Color? { get set }
    var baselineOffset: CGFloat? { get set }
    var isBold: Bool? { get set }
    var isItalic: Bool? { get set }
    var isUnderline: Bool? { get set }
    var kerning: CGFloat? { get set }
    var strikethrough: Bool? { get set }
    var isMonospacedDigit: Bool? { get set }
}

extension TextBuildable {

    func set<V>(_ keypath: WritableKeyPath<Self, V>, to value: V) -> Self {
        var copy = self
        copy[keyPath: keypath] = value
        return copy
    }
}

public extension Text {

    /// Returns a modified Orbit text with provided font weight.
    ///
    /// - Parameters:
    ///   - weight: One of the available font weights. When the value is `nil`, the environment value will be used instead.
    func fontWeight(_ weight: Font.Weight?) -> Self {
        set(\.fontWeight, to: weight)
    }

    /// Returns a modified Orbit text with provided color.
    ///
    /// - Parameters:
    ///   - color: The color to use when displaying this text.
    ///   When the value is `nil`,  the environment value `textColor` or the default `inkDark` color will be used in this order.
    func textColor(_ color: Color?) -> Self {
        set(\.color, to: color)
    }

    /// Returns a modified Orbit text with provided accent color.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in `<ref>` tags in this text. When the value is `nil`, the environment value will be used instead.
    func textAccentColor(_ accentColor: Color?) -> Self {
        set(\.accentColor, to: accentColor)
    }

    /// Returns a modified Orbit text with applied vertical offset for the text relative to its baseline.
    ///
    /// - Parameters:
    ///   - baselineOffset: The amount to shift the text vertically (up or down) relative to its baseline.
    func baselineOffset(_ baselineOffset: CGFloat) -> Self {
        self.baselineOffset(baselineOffset as CGFloat?)
    }

    /// Returns a modified Orbit text with applied vertical offset for the text relative to its baseline.
    ///
    /// - Parameters:
    ///   - baselineOffset: The amount to shift the text vertically (up or down) relative to its baseline. When the value is `nil`, the environment value will be used instead.
    func baselineOffset(_ baselineOffset: CGFloat?) -> Self {
        set(\.baselineOffset, to: baselineOffset)
    }

    /// Returns a modified Orbit text with applied bold font weight.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. If left unspecified, the default is true.
    func bold(_ isActive: Bool = true) -> Self {
        self.bold(isActive as Bool?)
    }

    /// Returns a modified Orbit text with applied bold font weight.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. When the value is `nil`, the environment value will be used instead.
    func bold(_ isActive: Bool?) -> Self {
        set(\.isBold, to: isActive)
    }

    /// Returns a modified Orbit text with applied italics.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. If left unspecified, the default is true.
    func italic(_ isActive: Bool = true) -> Self {
        self.italic(isActive as Bool?)
    }

    /// Returns a modified Orbit text with applied italics.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. When the value is `nil`, the environment value will be used instead.
    func italic(_ isActive: Bool?) -> Self {
        set(\.isItalic, to: isActive)
    }

    /// Returns a modified Orbit text with applied spacing, or kerning, between characters.
    ///
    /// - Parameters:
    ///   - kerning: The spacing to use between individual characters in this text. Value of 0 sets the kerning to the system default value.
    func kerning(_ kerning: CGFloat) -> Self {
        self.kerning(kerning as CGFloat?)
    }

    /// Returns a modified Orbit text with applied spacing, or kerning, between characters.
    ///
    /// - Parameters:
    ///   - kerning: The spacing to use between individual characters in this text. Value of 0 sets the kerning to the system default value. When the value is `nil`, the environment value will be used instead.
    func kerning(_ kerning: CGFloat?) -> Self {
        set(\.kerning, to: kerning)
    }

    /// Returns a modified Orbit text with applied fixed-width digits, while leaving other characters proportionally spaced.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the text has a fixed-width digits style applied. When the value is `nil`, the environment value will be used instead.
    func monospacedDigit(_ isActive: Bool? = true) -> Self {
        set(\.isMonospacedDigit, to: isActive)
    }

    /// Returns a modified Orbit text with applied strikethrough.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the text has a strikethrough applied. If left unspecified, the default is true.
    func strikethrough(_ isActive: Bool = true) -> Self {
        self.strikethrough(isActive as Bool?)
    }

    /// Returns a modified Orbit text with applied strikethrough.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the text has a strikethrough applied. When the value is `nil`, the environment value will be used instead.
    func strikethrough(_ isActive: Bool?) -> Self {
        set(\.strikethrough, to: isActive)
    }

    /// Returns a modified Orbit text with applied underline.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the underline style is in effect. If left unspecified, the default is true.
    func underline(_ isActive: Bool = true) -> Self {
        self.underline(isActive as Bool?)
    }

    /// Returns a modified Orbit text with applied underline.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the underline style is in effect. When the value is `nil`, the environment value will be used instead.
    func underline(_ isActive: Bool?) -> Self {
        set(\.isUnderline, to: isActive)
    }
}

public extension Heading {

    /// Returns a modified Orbit heading with provided font weight.
    ///
    /// - Parameters:
    ///   - weight: One of the available font weights. When the value is `nil`, the environment value will be used instead.
    func fontWeight(_ weight: Font.Weight?) -> Self {
        set(\.fontWeight, to: weight)
    }

    /// Returns a modified Orbit heading with provided accent color.
    ///
    /// When the value is `nil`, the environment value will be used instead.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in `<ref>` tags in this heading.
    func textAccentColor(_ accentColor: Color?) -> Self {
        set(\.accentColor, to: accentColor)
    }

    /// Returns a modified Orbit heading with provided color.
    ///
    /// - Parameters:
    ///   - color: The color to use when displaying this heading.
    ///   When the value is `nil`,  the environment value `textColor` or the default `inkDark` color will be used in this order.
    func textColor(_ color: Color?) -> Self {
        set(\.color, to: color)
    }

    /// Returns a modified Orbit heading with applied vertical offset for the text relative to its baseline.
    ///
    /// - Parameters:
    ///   - baselineOffset: The amount to shift the text vertically (up or down) relative to its baseline.
    func baselineOffset(_ baselineOffset: CGFloat) -> Self {
        self.baselineOffset(baselineOffset as CGFloat?)
    }

    /// Returns a modified Orbit heading with applied vertical offset for the text relative to its baseline.
    ///
    /// - Parameters:
    ///   - baselineOffset: The amount to shift the text vertically (up or down) relative to its baseline. When the value is `nil`, the environment value will be used instead.
    func baselineOffset(_ baselineOffset: CGFloat?) -> Self {
        set(\.baselineOffset, to: baselineOffset)
    }

    /// Returns a modified Orbit heading with applied bold font weight.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. If left unspecified, the default is true.
    func bold(_ isActive: Bool = true) -> Self {
        self.bold(isActive as Bool?)
    }

    /// Returns a modified Orbit heading with applied bold font weight.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. When the value is `nil`, the environment value will be used instead.
    func bold(_ isActive: Bool?) -> Self {
        set(\.isBold, to: isActive)
    }

    /// Returns a modified Orbit heading with applied italics.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. If left unspecified, the default is true.
    func italic(_ isActive: Bool = true) -> Self {
        self.italic(isActive as Bool?)
    }

    /// Returns a modified Orbit heading with applied italics.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the bold style is in effect. When the value is `nil`, the environment value will be used instead.
    func italic(_ isActive: Bool?) -> Self {
        set(\.isItalic, to: isActive)
    }

    /// Returns a modified Orbit heading with applied spacing, or kerning, between characters.
    ///
    /// - Parameters:
    ///   - kerning: The spacing to use between individual characters in this text. Value of 0 sets the kerning to the system default value. When the value is `nil`, the environment value will be used instead.
    func kerning(_ kerning: CGFloat) -> Self {
        set(\.kerning, to: kerning)
    }

    /// Returns a modified Orbit heading with applied fixed-width digits, while leaving other characters proportionally spaced.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the heading has a fixed-width digits style applied.
    func monospacedDigit() -> Self {
        self.monospacedDigit(true)
    }

    /// Returns a modified Orbit heading with applied fixed-width digits, while leaving other characters proportionally spaced.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the heading has a fixed-width digits style applied. When the value is `nil`, the environment value will be used instead.
    func monospacedDigit(_ isActive: Bool? = true) -> Self {
        set(\.isMonospacedDigit, to: isActive)
    }

    /// Returns a modified Orbit heading with applied strikethrough.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the text has a strikethrough applied.
    func strikethrough(_ isActive: Bool = true) -> Self {
        self.strikethrough(isActive as Bool?)
    }

    /// Returns a modified Orbit heading with applied strikethrough.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value that indicates whether the text has a strikethrough applied. When the value is `nil`, the environment value will be used instead.
    func strikethrough(_ isActive: Bool?) -> Self {
        set(\.strikethrough, to: isActive)
    }

    /// Returns a modified Orbit heading with applied underline.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the underline style is in effect. If left unspecified, the default is true.
    func underline(_ isActive: Bool = true) -> Self {
        self.underline(isActive as Bool?)
    }

    /// Returns a modified Orbit heading with applied underline.
    ///
    /// - Parameters:
    ///   - isActive: A boolean that indicates if the underline style is in effect. When the value is `nil`, the environment value will be used instead.
    func underline(_ isActive: Bool?) -> Self {
        set(\.isUnderline, to: isActive)
    }
}
