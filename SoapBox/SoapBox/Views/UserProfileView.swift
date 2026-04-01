import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var postStore: PostStore
    @Environment(\.dismiss) private var dismiss

    let user: User
    @State private var selectedTab: ProfileTab = .posts
    @State private var showEditProfile = false
    @State private var showNetwork = false
    @State private var selectedNetworkTab: NetworkTab = .interests

    enum ProfileTab: String, CaseIterable {
        case likes = "Likes"
        case posts = "Posts"
        case comments = "Comments"
        case votes = "Votes"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header video area
                headerVideo

                // Profile info section
                profileInfo

                // Stats row
                statsRow

                // Content tabs
                tabBar

                // Tab content
                tabContent
            }
        }
        .background(.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("SoapBox")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("AccentColor"))
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showEditProfile) {
            NavigationStack {
                EditProfileView(user: user)
            }
        }
        .sheet(isPresented: $showNetwork) {
            NavigationStack {
                NetworkListView(
                    user: user,
                    initialTab: selectedNetworkTab
                )
            }
        }
    }

    // MARK: - Header Video

    private var headerVideo: some View {
        ZStack {
            LinearGradient(
                colors: [.purple.opacity(0.4), .blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // SoapBox title overlaid
            VStack {
                Text("SoapBox")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("AccentColor").opacity(0.6))
                    .padding(.top, 12)
                Spacer()
            }

            // Mute icon bottom-right
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "speaker.slash.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(12)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.35)
    }

    // MARK: - Profile Info

    private var profileInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                // Avatar (overlapping the video)
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 26))
                    )
                    .offset(y: -20)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(user.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                        Text(user.handle)
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                    }

                    // Bio
                    Text(user.bio)
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(3)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)

            // Info row: joined, location, link
            HStack(spacing: 16) {
                if !user.joinedDate.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                        Text(user.joinedDate)
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(.gray)
                }

                if !user.location.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle")
                            .font(.system(size: 12))
                        Text(user.location)
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(.gray)
                }

                if !user.website.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                            .font(.system(size: 12))
                        Text(user.website)
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, -10)
        }
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 6) {
            statButton(count: user.interestsCount, label: "Interests") {
                selectedNetworkTab = .interests
                showNetwork = true
            }
            statButton(count: user.followingCount, label: "Following") {
                selectedNetworkTab = .following
                showNetwork = true
            }
            statButton(count: user.followersCount, label: "Followers") {
                selectedNetworkTab = .followers
                showNetwork = true
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private func statButton(count: Int, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text("\(count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray)
            }
        }
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 6) {
                        Text(tab.rawValue)
                            .font(.system(size: 14, weight: selectedTab == tab ? .bold : .regular))
                            .foregroundStyle(selectedTab == tab ? .white : .gray)
                        Rectangle()
                            .fill(selectedTab == tab ? Color("AccentColor") : .clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 12)
    }

    // MARK: - Tab Content

    private var tabContent: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .posts:
                ForEach(postStore.posts.filter { $0.author.handle == user.handle }) { post in
                    PostCardView(post: post)
                    Divider().background(Color.gray.opacity(0.3))
                }
                if postStore.posts.filter({ $0.author.handle == user.handle }).isEmpty {
                    emptyTab(icon: "video.fill", text: "No posts yet")
                }
            case .likes:
                emptyTab(icon: "hand.thumbsup", text: "No liked posts yet")
            case .comments:
                emptyTab(icon: "bubble.left", text: "No comments yet")
            case .votes:
                emptyTab(icon: "arrow.up.arrow.down", text: "No votes yet")
            }
        }
        .padding(.bottom, 80)
    }

    private func emptyTab(icon: String, text: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(.gray.opacity(0.5))
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

#Preview {
    NavigationStack {
        UserProfileView(user: .currentUser)
            .environmentObject(PostStore())
    }
    .preferredColorScheme(.dark)
}
