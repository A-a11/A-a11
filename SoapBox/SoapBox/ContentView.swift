import SwiftUI

enum Tab {
    case home, search, record, collections, message
}

struct ContentView: View {
    @EnvironmentObject var postStore: PostStore
    @State private var selectedTab: Tab = .home
    @State private var showRecordView = false
    @State private var showSideMenu = false
    @State private var showProfile = false
    @State private var showSettings = false
    @State private var menuDragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Main content
            ZStack(alignment: .bottom) {
                // Tab content
                Group {
                    switch selectedTab {
                    case .home:
                        HomeFeedView(onAvatarTap: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showSideMenu = true
                            }
                        })
                    case .search:
                        SearchView()
                    case .record:
                        Color.black
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
            .offset(x: showSideMenu ? UIScreen.main.bounds.width * 0.6 : 0)

            // Side menu overlay
            if showSideMenu {
                ProfileSideMenuView(
                    isOpen: $showSideMenu,
                    user: .currentUser,
                    onProfile: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showSideMenu = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showProfile = true
                        }
                    },
                    onSettings: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showSideMenu = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showSettings = true
                        }
                    }
                )
                .transition(.move(edge: .leading))
            }
        }
        .background(.black)
        .ignoresSafeArea(.keyboard)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !showSideMenu && value.translation.width > 20 && value.startLocation.x < 40 {
                        menuDragOffset = value.translation.width
                    }
                }
                .onEnded { value in
                    if !showSideMenu && value.translation.width > 100 && value.startLocation.x < 40 {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showSideMenu = true
                        }
                    }
                    menuDragOffset = 0
                }
        )
        .fullScreenCover(isPresented: $showRecordView) {
            RecordView()
        }
        .fullScreenCover(isPresented: $showProfile) {
            NavigationStack {
                UserProfileView(user: .currentUser)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showProfile = false
                            } label: {
                                Image(systemName: "arrow.left")
                                    .foregroundStyle(.white)
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                EditProfileView(user: .currentUser)
            }
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
