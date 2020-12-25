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
    @State var frontReturnKeyType = OmenTextField.ReturnKeyType.next

    @State var backText = ""

    @State var isFinished = false

    @State var focus: Focus?

    enum Focus {
        case front, back
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Front")) {
                    OmenTextField(
                        "Front",
                        text: $frontText,
                        isFocused: $focus.equalTo(.front),
                        returnKeyType: frontReturnKeyType
                    ) {
                        focus = .back
                    }

                    #if os(iOS)
                        returnKeyPicker()
                    #endif
                }

                Section(header: Text("Back")) {
                    OmenTextField(
                        "Back",
                        text: $backText,
                        isFocused: $focus.equalTo(.back),
                        returnKeyType: .done
                    ) {
                        focus = nil
                        frontText = ""
                        backText = ""
                        isFinished = true
                    }
                }

                Section(header: Text("Focus")) {
                    Toggle(isOn: $focus.equalTo(.front), label: {
                        Text("Front Focused")
                    })

                    Toggle(isOn: $focus.equalTo(.back), label: {
                        Text("Back Focused")
                    })
                }
            }
            .onAppear {
                // NOTE: Unfortunately, one must occasionally muck with delays when dealing with
                // `becomeFirstResponder` and SwiftUI. Ideally, this can be moved into the
                // `OmenTextViewRep`, perhaps it can repeatedly attempt to `becomeFirstResponder`
                // until it succeeds. I'm just wary of infinite loops.
                // FURTHERMORE: This delay is only necessary when within a NavigationView.
                // It appears that NavigationView steals the focus on load somehow.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    focus = .front
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

extension Binding {
    func equalTo<A: Equatable>(_ value: A) -> Binding<Bool> where Value == A? {
        Binding<Bool> {
            wrappedValue == value
        } set: {
            if $0 {
                wrappedValue = value
            } else if wrappedValue == value {
                wrappedValue = nil
            }
        }
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
