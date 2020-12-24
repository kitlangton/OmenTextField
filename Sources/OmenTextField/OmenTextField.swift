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
        _text = text
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
//        .animation(nil)
    }
}
