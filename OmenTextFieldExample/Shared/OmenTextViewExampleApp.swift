//
//  OmenTextFieldExampleApp.swift
//  Shared
//
//  Created by Kit Langton on 12/22/20.
//

import OmenTextField
import SwiftUI

@main
struct OmenTextFieldExampleApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
                NavigationView {
                    ExampleView()
                        .navigationTitle("Example")
                }
            #elseif os(macOS)
                ExampleView()
                    .padding()
                    .frame(width: 400)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
            #endif
        }
    }
}
