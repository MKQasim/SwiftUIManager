// MARK: - CustomNavigationBarView
//
//  CustomNavigationBar.swift
//  HackerUITaskSwift
//
//  Created by KamsQue on 22/03/2023.
//

import SwiftUI
import Swift


// MARK: - IdentifiableNavigationItem

@available(iOS 13.0, *)
public struct IdentifiableNavigationItem: Identifiable {
    public let id = UUID()
    public let item: AnyView

    public var view: AnyView {
        item
    }
}

// MARK: - NavigationAction
@available(iOS 13.0, *)
public protocol ControlAction {
    var action: (() -> Void)? { get }
}

@available(iOS 13.0, *)
public protocol NavigationControlButton {
    var setImageOnControl: Image? { get }
    var title: String? { get }
    var color: Color? { get }
}

// MARK: - Navigation Item

@available(iOS 13.0, *)
public struct NavigationItem {
    var content: () -> AnyView

    public init(@ViewBuilder content: @escaping () -> AnyView) {
        self.content = content
    }
}

@available(iOS 13.0, *)
public extension NavigationItem {
    init<T: ControlAction & NavigationControlButton>(
        _ item: T
    ) {
        self.content = {
            if let action = item.action {
                return AnyView(
                    Button(action: action) {
                        HStack {
                            if let image = item.setImageOnControl {
                                image
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(item.color ?? .white)
                            }
                            if let title = item.title {
                                Text(title)
                                    .font(.headline)
                            }
                        }
                    }
                )
            } else {
                return AnyView(EmptyView())
            }
        }
    }
}

@available(iOS 13.0, *)
public struct CustomNavigationBarView: ViewModifier {
    public var title: String
    public var leftItems: [NavigationItem]
    public var rightItems: [NavigationItem]
    
    public init(title: String, leftItems: [NavigationItem] = [], rightItems: [NavigationItem] = []) {
        self.title = title
        self.leftItems = leftItems
        self.rightItems = rightItems
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            HStack {
                leftItemsStack
                Spacer()
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                rightItemsStack
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.blue.edgesIgnoringSafeArea(.top))
            
            content
        }
    }
    
    public var leftItemsStack: some View {
        HStack(spacing: 16) {
            ForEach(leftItems.map { IdentifiableNavigationItem(item: $0.content()) }, id: \.id) { item in
                item.view
            }
        }
        .padding(.leading, 16)
    }
    
    public var rightItemsStack: some View {
        HStack(spacing: 16) {
            ForEach(rightItems.map { IdentifiableNavigationItem(item: $0.content()) }, id: \.id) { item in
                item.view
            }
        }
        .padding(.trailing, 16)
    }
}
// MARK: - IdentifiableNavigationItem

@available(iOS 13.0, *)
public struct NavigationTitleView: View {
    let title: String
    let color: Color
    
    public init(title: String, color: Color) {
        self.title = title
        self.color = color
    }
    
    public var body: some View {
        Text(title)
            .frame(maxWidth: title.count == 0 ? .zero : .infinity)
            .font(.headline)
            .foregroundColor(color)
    }
}

@available(iOS 13.0, *)
public struct CurvedShapeView: Shape {
    let curveHeight: CGFloat
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: curveHeight))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: curveHeight), control: CGPoint(x: rect.width / 2, y: curveHeight + 20))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()
        return path
    }
}

@available(iOS 13.0, *)
public enum BackgroundStyle {
    case color(Color)
    case gradient(Gradient)
}

@available(iOS 13.0, *)
public struct CurvedGradientNavigation<Content: View>: View {
    var title: String
    var titleColor: Color = .white
    var backgroundColor: Color
    var content: Content
    var leftItems: [AnyView]?
    var rightItems: [AnyView]?
    var curveHeight: CGFloat = 50
    var gradientColors: [Color]?
    
    init(title: String, backgroundColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ZStack {
                    CurvedShape(curveHeight: curveHeight)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: gradientColors ?? [backgroundColor, backgroundColor.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: curveHeight)
                    
                    HStack {
                        if let leftItems = leftItems {
                            HStack(spacing: 16) {
                                ForEach(leftItems.indices, id: \.self) { index in
                                    leftItems[index]
                                }
                            }
                            .padding(.leading, 16)
                        }
                        
                        Spacer()
                        
                        Text(title)
                        frame(width: title.count > 0 ? .infinity : .zero , height: 40)
                            .font(.headline)
                            .foregroundColor(titleColor)
                            .padding(.top, curveHeight/2)
                        
                        Spacer()
                        
                        if let rightItems = rightItems {
                            HStack(spacing: 16) {
                                ForEach(rightItems.indices, id: \.self) { index in
                                    rightItems[index]
                                }
                            }
                            .padding(.trailing, 16)
                        }
                    }
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                    .padding(.horizontal, 16)
                }
                content
            }
        }
    }
}

public struct CurvedShape: Shape {
    var curveHeight: CGFloat = 50
    
    @available(iOS 13.0, *)
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.maxY - curveHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: 0, y: rect.minY))
        path.closeSubpath()
        return path
    }
}




