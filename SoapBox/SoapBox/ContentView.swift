import SwiftUI

enum Tab {
    case home, search, record, collections, message
}

struct ContentView: View {
    @EnvironmentObject var postStore: PostStore
    @State private var selectedTab: Tab = .home
    @State private var showRecordView = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            Group {
                switch selectedTab {
                case .home:
                    HomeFeedView()
                case .search:
                    SearchView()
                case .record:
                    Color.black // Placeholder, record is a sheet
                case .collections:
                    CollectionsView()
                case .message:
                    MessageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom tab bar
            customTabBar
        }
        .background(.black)
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $showRecordView) {
            RecordView()
        }
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(icon: "house.fill", label: "Home", tab: .home)
            tabButton(icon: "magnifyingglass", label: "Search", tab: .search)
            recordButton
            tabButton(icon: "square.grid.2x2.fill", label: "Collections", tab: .collections)
            tabButton(icon: "bubble.left.and.bubble.right.fill", label: "Message", tab: .message)
        }
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(
            Rectangle()
                .fill(.black)
                .shadow(color: .white.opacity(0.05), radius: 8, y: -4)
        )
    }

    private func tabButton(icon: String, label: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 10))
            }
            .foregroundStyle(selectedTab == tab ? .white : .gray)
            .frame(maxWidth: .infinity)
        }
    }

    private var recordButton: some View {
        Button {
            showRecordView = true
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 52, height: 52)

                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.black)
            }
            .offset(y: -16)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
        .environmentObject(PostStore())
        .preferredColorScheme(.dark)
}
