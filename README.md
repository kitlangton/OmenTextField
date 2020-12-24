# OmenTextField

A better TextField for SwiftUI. A growing, multiline, auto-focusable TextField supporting bindable focus.

This has been pulled out of my flashcard app, [Omen](https://omen.cards)—in case you need some help memorizing SwiftUI overloads 😜

<img src="/OmenTextFieldExample/iOS-version.gif" width="350"/>

<img src="/OmenTextFieldExample/macOS-version.gif" width="350"/>

## Example

A simple example app is included in the OmenTextFieldExample subproject.

## Installation with Swift Package Manager

You can add OmenTextField to an Xcode project by adding it as a package dependency.

1. From the File menu, select Swift Packages › Add Package Dependency…
2. Paste "https://github.com/kitlangton/OmenTextField" into the package repository URL text field
3. Hit Enter!

## To-do List

- [x] iOS support (using UITextView)
- [x] macOS support (using NSTextView)
- [x] Add overrideable `returnKey` for iOS
- [x] Add `onCommit` callback
