// The Swift Programming Language
// https://docs.swift.org/swift-book
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
