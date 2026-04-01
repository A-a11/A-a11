import SwiftUI

struct CollectionsView: View {
    @EnvironmentObject var postStore: PostStore

    private var bookmarkedPosts: [Post] {
        postStore.posts.filter { $0.isBookmarked }
    }

    private var likedPosts: [Post] {
        postStore.posts.filter { $0.userLiked }
    }

    private var myPosts: [Post] {
        postStore.posts.filter { $0.author.handle == User.currentUser.handle }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    collectionRow(
                        icon: "bookmark.fill",
                        title: "Bookmarked",
                        count: bookmarkedPosts.count,
                        color: .yellow
                    )
                    collectionRow(
                        icon: "hand.thumbsup.fill",
                        title: "Liked",
                        count: likedPosts.count,
                        color: Color("AccentColor")
                    )
                    collectionRow(
                        icon: "person.fill",
                        title: "My Posts",
                        count: myPosts.count,
                        color: .blue
                    )
                    collectionRow(
                        icon: "arrow.2.squarepath",
                        title: "Reposted",
                        count: postStore.posts.filter(\.userReposted).count,
                        color: .green
                    )
                }
                .listRowBackground(Color(.systemGray6).opacity(0.15))
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(.black)
            .navigationTitle("Collections")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private func collectionRow(icon: String, title: String, count: Int, color: Color) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.system(size: 16))
            }

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)

            Spacer()

            Text("\(count)")
                .font(.system(size: 15))
                .foregroundStyle(.gray)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    CollectionsView()
        .environmentObject(PostStore())
        .preferredColorScheme(.dark)
}
