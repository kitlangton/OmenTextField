//
//  ContentView.swift
//  Shared
//
//  Created by Kit Langton on 12/22/20.
//

import OmenTextField
import SwiftUI

public struct ExampleView: View {
    @State var frontText = ""
    @State var frontFocused = false

    @State var backText = ""
    @State var backFocused = false

    public init() {}

    public var body: some View {
        Form {
            Section(header: Text("Front")) {
                OmenTextField("Front", text: $frontText, isFocused: $frontFocused)
            }

            Section(header: Text("Back")) {
                OmenTextField("Back", text: $backText, isFocused: $backFocused)
            }

            Section(header: Text("Focus")) {
                Toggle(isOn: $frontFocused, label: {
                    Text("Front Focused")
                })

                Toggle(isOn: $backFocused, label: {
                    Text("Back Focused")
                })
            }
        }
        .animation(.spring())
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExampleView()
                .navigationTitle("Example")
        }
        .preferredColorScheme(.dark)
    }
}
