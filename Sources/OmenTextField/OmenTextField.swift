//
//  SwiftUIView 2.swift
//
//
//  Created by Kit Langton on 12/22/20.
//

import SwiftUI

public struct OmenTextField: View {
    var title: String
    @Binding var text: String
    var isFocused: Binding<Bool>?
    @State var height: CGFloat = 0
    var returnKeyType: ReturnKeyType
    var onCommit: (() -> Void)?

    /// Creates a multiline text field with a text label.
    ///
    /// - Parameters:
    ///   - title: The title of the text field.
    ///   - text: The text to display and edit.
    ///   - isFocused: Whether or not the field should be focused.
    ///   - returnKeyType: The type of return key to be used on iOS.
    ///   - onCommit: An action to perform when the user presses the
    ///     Return key) while the text field has focus. If `nil`, a newline
    ///     will be inserted.
    public init<S: StringProtocol>(
        _ title: S,
        text: Binding<String>,
        isFocused: Binding<Bool>? = nil,
        returnKeyType: ReturnKeyType = .default,
        onCommit: (() -> Void)? = nil
    ) {
        self.title = String(title)
        _text = text
        self.isFocused = isFocused
        self.returnKeyType = returnKeyType
        self.onCommit = onCommit
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(title).foregroundColor(.secondary).opacity(0.5)
            }
            OmenTextFieldRep(
                text: $text,
                isFocused: isFocused,
                height: $height,
                returnKeyType: returnKeyType,
                onCommit: onCommit
            )
            .frame(height: height)
        }
    }
}

// MARK: - ReturnKeyType

public extension OmenTextField {
    enum ReturnKeyType {
        case done
        case next
        case `default`
        case `continue`

        #if os(iOS)
            var uiReturnKey: UIReturnKeyType {
                switch self {
                case .done:
                    return .done
                case .next:
                    return .next
                case .default:
                    return .default
                case .continue:
                    return .continue
                }
            }
        #endif
    }
}
