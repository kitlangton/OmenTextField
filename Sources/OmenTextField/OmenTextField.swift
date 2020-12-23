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

    public init(_ title: String, text: Binding<String>, isFocused: Binding<Bool>? = nil) {
        self.title = title
        self._text = text
        self.isFocused = isFocused
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(title).foregroundColor(.secondary).opacity(0.5)
            }
            OmenTextFieldRep(text: $text, isFocused: isFocused, height: $height)
                .frame(height: height)
        }
        .animation(nil)
    }
}

struct OmenTextFieldRep: UIViewRepresentable {
    @Binding var text: String
    var isFocused: Binding<Bool>?
    @Binding var height: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        uiView.font = UIFont.preferredFont(forTextStyle: .body)
        uiView.backgroundColor = .clear
        uiView.delegate = context.coordinator
        uiView.textContainerInset = .zero
        uiView.textContainer.lineFragmentPadding = 0
        uiView.text = text
        height = uiView.textHeight()
        return uiView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
            height = uiView.textHeight()
        }

        if let isFocused = isFocused?.wrappedValue {
            if isFocused, !uiView.isFirstResponder {
                uiView.becomeFirstResponder()
            } else if !isFocused, uiView.isFirstResponder {
                uiView.resignFirstResponder()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(rep: self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        let rep: OmenTextFieldRep

        internal init(rep: OmenTextFieldRep) {
            self.rep = rep
        }

        func textViewDidChange(_ textView: UITextView) {
            rep.text = textView.text
            rep.height = textView.textHeight()
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            rep.isFocused?.wrappedValue = true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            rep.isFocused?.wrappedValue = false
        }
    }
}

extension UITextView {
    func textHeight() -> CGFloat {
        sizeThatFits(
            CGSize(
                width: frame.size.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        .height
    }
}
