import SwiftUI

enum NetworkTab: String, CaseIterable {
    case interests = "Interests"
    case following = "Following"
    case followers = "Followers"
}

struct NetworkListView: View {
    @Environment(\.dismiss) private var dismiss

    let user: User
    @State var initialTab: NetworkTab

    private let sampleUsers = User.sampleUsers

    var body: some View {
        VStack(spacing: 0) {
            // Tab header: Interests | Following | Followers
            HStack(spacing: 0) {
                ForEach(NetworkTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            initialTab = tab
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(countFor(tab))")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(initialTab == tab ? .white : .gray)
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: initialTab == tab ? .bold : .regular))
                                .foregroundStyle(initialTab == tab ? .white : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    if tab != .followers {
                        Text("|")
                            .foregroundStyle(.gray.opacity(0.4))
                    }
                }
            }
            .padding(.vertical, 12)

            Divider()
                .background(Color.gray.opacity(0.3))

            // User list
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(sampleUsers) { listUser in
                        userRow(listUser)
                        Divider()
                            .background(Color.gray.opacity(0.15))
                    }
                }
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func userRow(_ listUser: User) -> some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                )

            // Name & handle
            HStack(spacing: 0) {
                Text(listUser.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text("  \(listUser.handle)")
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }

            Text("\u{2022}")
                .foregroundStyle(.gray)

            Text("\(listUser.followingCount)")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
            + Text(" Following")
                .font(.system(size: 14))
                .foregroundStyle(.gray)

            Spacer()

            // Follow button
            Button {
                // follow/unfollow
            } label: {
                Text("Follow")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.white.opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func countFor(_ tab: NetworkTab) -> Int {
        switch tab {
        case .interests: return user.interestsCount
        case .following: return user.followingCount
        case .followers: return user.followersCount
        }
    }
}

#Preview {
    NavigationStack {
        NetworkListView(user: .currentUser, initialTab: .following)
    }
    .preferredColorScheme(.dark)
}
