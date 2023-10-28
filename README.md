# SwiftUIManager
SwiftUIManager to manage swiftui code in UIkit project.

```swift
import SwiftUI

@available(iOS 13.0, *)
extension View {
    public func centeredHorizental() -> some View{
        HStack{
            Spacer()
            self
            Spacer()
        }
    }
}
