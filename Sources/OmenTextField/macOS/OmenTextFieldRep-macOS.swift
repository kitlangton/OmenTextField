//
//  File.swift
//
//
//  Created by Kit Langton on 12/23/20.
//

import SwiftUI

#if os(macOS)
    struct OmenTextFieldRep: NSViewRepresentable {
        @Binding var text: String
        var isFocused: Binding<Bool>?
        @Binding var height: CGFloat

        // Unused in macOS, but retained for API parity.
        var returnKeyType: OmenTextField.ReturnKeyType

        var onCommit: (() -> Void)?

        func makeNSView(context: Context) -> NSTextView {
            let view = CustomNSTextView(rep: self)
            view.font = NSFont.preferredFont(forTextStyle: .body)
            view.backgroundColor = .clear
            view.delegate = context.coordinator
            view.textContainerInset = .zero
            view.textContainer?.lineFragmentPadding = 0
            view.string = text
            DispatchQueue.main.async {
                height = view.textHeight()
            }
            return view
        }

        func updateNSView(_ view: NSTextView, context _: Context) {
            if view.string != text {
                view.string = text
                DispatchQueue.main.async {
                    height = view.textHeight()
                }
            }

            if let isFocused = isFocused?.wrappedValue {
                DispatchQueue.main.async {
                    let isFirstResponder = view.window?.firstResponder == view
                    if isFocused, view.window != nil, !isFirstResponder {
                        view.window?.makeFirstResponder(view)
                    } else if !isFocused, isFirstResponder {
                        view.window?.makeFirstResponder(nil)
                    }
                }
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(rep: self)
        }

        class Coordinator: NSObject, NSTextViewDelegate {
            let rep: OmenTextFieldRep

            internal init(rep: OmenTextFieldRep) {
                self.rep = rep
            }

            func textDidChange(_ notification: Notification) {
                guard let view = notification.object as? NSTextView else { return }

                rep.text = view.string
                DispatchQueue.main.async {
                    self.rep.height = view.textHeight()
                }
            }

            func textView(_: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
                // Call `onCommit` when the Return key is pressed without Shift.
                // If Shift-Return is pressed, a newline will be inserted.
                if commandSelector == #selector(NSResponder.insertNewline(_:)),
                   let event = NSApp.currentEvent,
                   !event.modifierFlags.contains(.shift)
                {
                    rep.onCommit?()
                    return true
                }

                return false
            }
        }
    }

    /// This is necessary because `textDidBeginEditing` on `NSTextViewDelegate` only triggers once the user types.
    class CustomNSTextView: NSTextView {
        let rep: OmenTextFieldRep

        internal init(rep: OmenTextFieldRep) {
            self.rep = rep

            super.init(frame: .zero, textContainer: NSTextView().textContainer)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func becomeFirstResponder() -> Bool {
            rep.isFocused?.wrappedValue = true
            return super.becomeFirstResponder()
        }

        override func resignFirstResponder() -> Bool {
            rep.isFocused?.wrappedValue = false
            return super.resignFirstResponder()
        }
    }

    extension NSTextView {
        func textHeight() -> CGFloat {
            if let layoutManager = layoutManager,
               let container = layoutManager.textContainers.first
            {
                return layoutManager.usedRect(for: container).height
            } else {
                return frame.height
            }
        }
    }
#endif
