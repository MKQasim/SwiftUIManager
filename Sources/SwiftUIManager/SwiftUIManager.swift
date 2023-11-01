import SwiftUI

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
            ForEach(leftItems.map { IdentifiableNavigationItem(item: $0.view) }, id: \.id) { item in
                item.view
            }
        }
        .padding(.leading, 16)
    }

    public var rightItemsStack: some View {
        HStack(spacing: 16) {
            ForEach(rightItems.map { IdentifiableNavigationItem(item: $0.view) }, id: \.id) { item in
                item.view
            }
        }
        .padding(.trailing, 16)
    }
}

// MARK: - View Extension

@available(iOS 13.0, *)
public extension View {
    func customNavigationBar<Content: View>(
        title: String,
        leftItems: [NavigationItem] = [],
        rightItems: [NavigationItem] = [],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(CustomNavigationBarView(title: title, leftItems: leftItems, rightItems: rightItems))
    }
}


// MARK: - IdentifiableNavigationItem

@available(iOS 13.0, *)
struct IdentifiableNavigationItem: Identifiable {
    let id = UUID()
    let item: AnyView

    var view: AnyView {
        item
    }
}

// MARK: - NavigationItemType

@available(iOS 13.0, *)
enum NavigationItemType {
    case backButton(action: () -> Void)
    case profileButton(action: () -> Void)
    case moreButton(action: () -> Void)
    case doubleTitleText(title: String, subTitle: String)
    case customButton(view: AnyView)
    case spacer

    @available(iOS 16.0, *)
    var view: AnyView {
        switch self {
        case .backButton(let action):
            return AnyView(
                Button(action: action) {
                    Image("leftback")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                        .padding(.trailing, 15)
                }
            )

        case .profileButton(let action):
            return AnyView(
                Button(action: action) {
                    Image("navprofile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .padding(.trailing, 15)
                }
            )

        case .moreButton(let action):
            return AnyView(
                Button(action: action) {
                    Image("more")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                }
            )

        case .doubleTitleText(let title, let subTitle):
            return AnyView(
                VStack {
                    Text(title)
                        .frame(width: .infinity, height: 20, alignment: .leading)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)

                    Text(subTitle)
                        .frame(width: .infinity, height: 20, alignment: .leading)
                        .font(.system(size: 12))
                        .fontWeight(.regular)
                        .foregroundColor(Color.white)
                }
            )

        case .customButton(let view):
            return view

        case .spacer:
            return AnyView(Spacer())
        }
    }
}


// MARK: - NavigationItem

@available(iOS 13.0, *)
public protocol NavigationItem {
    var view: AnyView { get }
}

// MARK: - LeftNavigationItem

@available(iOS 13.0, *)
struct LeftNavigationItem: NavigationItem {
    let view: AnyView

    @available(iOS 16.0, *)
    init(_ type: NavigationItemType, spacer: Bool = false) {
        let itemView = type.view
        let spacerView = spacer ? AnyView(Spacer()) : AnyView(EmptyView())
        self.view = AnyView(HStack(spacing: 15) {
            spacerView
            itemView
        })
    }
}

// MARK: - RightNavigationItem

@available(iOS 13.0, *)
struct RightNavigationItem: NavigationItem {
    let view: AnyView

    @available(iOS 16.0, *)
    init(_ type: NavigationItemType, spacer: Bool = false) {
        let itemView = type.view
        let spacerView = spacer ? AnyView(Spacer()) : AnyView(EmptyView())
        self.view = AnyView(HStack {
            itemView
            spacerView
        })
    }
}

// MARK: - NavigationTitleView

@available(iOS 13.0, *)
struct NavigationTitleView: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .frame(maxWidth: title.count == 0 ? .zero : .infinity)
            .font(.headline)
            .foregroundColor(color)
    }
}
