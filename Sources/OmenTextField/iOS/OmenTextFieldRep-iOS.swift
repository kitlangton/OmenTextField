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
