//
//  ContentView.swift
//  Shared
//
//  Created by Kit Langton on 12/22/20.
//

import OmenTextField
import SwiftUI

struct ExampleView: View {
    @State var frontText = ""
    @State var frontFocused = false
    @State var frontReturnKeyType = OmenTextField.ReturnKeyType.next

    @State var backText = ""
    @State var backFocused = false

    @State var isFinished = false


    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Front")) {
                    OmenTextField(
                        "Front",
                        text: $frontText,
                        isFocused: $frontFocused,
                        returnKeyType: frontReturnKeyType
                    ) {
                        frontFocused = false
                        backFocused = true
                    }

                    #if os(iOS)
                        returnKeyPicker()
                    #endif
                }

                Section(header: Text("Back")) {
                    OmenTextField(
                        "Back",
                        text: $backText,
                        isFocused: $backFocused,
                        returnKeyType: .done
                    ) {
                        backFocused = false
                        frontText = ""
                        backText = ""
                        isFinished = true
                    }
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
            .onAppear {
                // NOTE: Unfortunately, one must occasionally muck with delays when dealing with
                // `becomeFirstResponder` and SwiftUI. Ideally, this can be moved into the
                // `OmenTextViewRep`, perhaps it can repeatedly attempt to `becomeFirstResponder`
                // until it succeeds. I'm just wary of infinite loops.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    frontFocused = true
                }
            }

            Text("FINISHED").bold()
                .padding()
                .background(Color.blue)
                .cornerRadius(3)
                .opacity(isFinished ? 1 : 0)
                .offset(y: isFinished ? 0 : 20)
                .onChange(of: isFinished, perform: { isFinished in
                    if isFinished {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isFinished = false
                        }
                    }
                })
        }
        .animation(.spring())
    }

    #if os(iOS)
        func returnKeyPicker() -> some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(OmenTextField.ReturnKeyType.allCases, id: \.self) { returnKeyType in
                        Text(returnKeyType.rawValue)
                            .padding(4)
                            .padding(.horizontal, 4)
                            .background(frontReturnKeyType == returnKeyType ? Color.blue :
                                Color.clear)
                            .cornerRadius(3)
                            .animation(.interactiveSpring())
                            .onTapGesture {
                                frontReturnKeyType = returnKeyType
                                UISelectionFeedbackGenerator().selectionChanged()
                            }
                    }
                }
            }
        }
    #endif
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
