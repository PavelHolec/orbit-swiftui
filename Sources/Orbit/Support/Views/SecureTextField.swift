import SwiftUI
import UIKit

struct SecureTextFieldStyle {
    let textContentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let font: UIFont
    let state: InputState
}

struct SecureTextField: UIViewRepresentable {
    typealias UIViewType = UITextField

    @Binding var text: String
    @Binding var isSecured: Bool
    @Binding var isEditing: Bool

    let style: SecureTextFieldStyle
    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let textFied = UITextField()
        textFied.autocorrectionType = .no
        textFied.delegate = context.coordinator

        textFied.text = text
        textFied.isSecureTextEntry = isSecured
        textFied.textContentType = style.textContentType
        textFied.keyboardType = style.keyboardType
        textFied.font = style.font
        textFied.textColor = style.state.textUIColor
        textFied.clearsOnBeginEditing = false
        textFied.isEnabled = style.state != .disabled

        if isEditing && textFied.canBecomeFirstResponder {
            textFied.becomeFirstResponder()
        }

        return textFied
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.isSecureTextEntry = isSecured

        guard uiView.isFirstResponder else {
            uiView.text = text
            return
        }

        if uiView.isSecureTextEntry && uiView.text == text {
            // Workaround. Without it, UITextField will erase it's own current value on frist input
            uiView.text?.removeAll()
            uiView.insertText(text)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing, onEditingChanged: onEditingChanged, onCommit: onCommit)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isEditing: Binding<Bool>
        let onEditingChanged: (Bool) -> Void
        let onCommit: () -> Void

        init(text: Binding<String>,
             isEditing: Binding<Bool>,
             onEditingChanged: @escaping (Bool) -> Void,
             onCommit: @escaping () -> Void
        ) {
            self.text = text
            self.isEditing = isEditing
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            isEditing.wrappedValue = true
            onEditingChanged(isEditing.wrappedValue)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }

            text.wrappedValue = textField.text ?? ""
            onCommit()

            isEditing.wrappedValue = false
            onEditingChanged(isEditing.wrappedValue)
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            if let input = textField.text,
                let specialRange = Range(range, in: input),
                specialRange.clamped(to: text.wrappedValue.startIndex..<text.wrappedValue.endIndex) == specialRange {

                text.wrappedValue.replaceSubrange(specialRange, with: string)
            } else {
                assertionFailure("Unexpected flow. Please report an issue.")
            }
            return true
        }
    }
}
