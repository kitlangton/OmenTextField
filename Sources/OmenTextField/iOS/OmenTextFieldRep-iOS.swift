//
//  File.swift
//
//
//  Created by Kit Langton on 12/23/20.
//

import SwiftUI

#if os(iOS)
    struct OmenTextFieldRep: UIViewRepresentable {
        @Binding var text: String
        var isFocused: Binding<Bool>?
        @Binding var height: CGFloat
        var returnKeyType: OmenTextField.ReturnKeyType
        var onCommit: (() -> Void)?

        func makeUIView(context: Context) -> UITextView {
            let uiView = UITextView()
            uiView.font = UIFont.preferredFont(forTextStyle: .body)
            uiView.backgroundColor = .clear
            uiView.delegate = context.coordinator
            uiView.textContainerInset = .zero
            uiView.textContainer.lineFragmentPadding = 0
            uiView.text = text
            uiView.returnKeyType = returnKeyType.uiReturnKey
            height = uiView.textHeight()
            return uiView
        }

        func updateUIView(_ uiView: UITextView, context _: Context) {
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

            func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
                guard let onCommit = rep.onCommit, text == "\n" else { return true }
                onCommit()
                return false
            }

            func textViewDidChange(_ textView: UITextView) {
                rep.text = textView.text
                rep.height = textView.textHeight()
            }

            func textViewDidBeginEditing(_: UITextView) {
                rep.isFocused?.wrappedValue = true
            }

            func textViewDidEndEditing(_: UITextView) {
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
#endif
