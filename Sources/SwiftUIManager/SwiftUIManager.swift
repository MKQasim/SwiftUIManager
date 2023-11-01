// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct CustomNavigationBarView: ViewModifier {
    var title: String

    init(title: String) {
        self.title = title
    }

    @available(iOS 13.0.0, *)
    @available(macOS 10.15.0, *)
    public func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) { // Change alignment to .topLeading
            content
            VStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.blue.edgesIgnoringSafeArea(.top))
        }
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension View {
    public func customNavigationBar<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        return ZStack(alignment: .top) {
            content()
            HStack {
                Spacer()
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.blue.edgesIgnoringSafeArea(.top))
        }
    }
}

