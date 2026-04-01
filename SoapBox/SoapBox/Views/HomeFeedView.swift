import SwiftUI

struct HomeFeedView: View {
    @EnvironmentObject var postStore: PostStore
    @State private var showingProfile = false

    var body: some View {
        VStack(spacing: 0) {
            FeedHeaderView(avatarAction: { showingProfile = true })

            if postStore.feedPosts.isEmpty {
                emptyFeed
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(postStore.feedPosts) { post in
                            PostCardView(post: post)

                            Divider()
                                .background(Color.gray.opacity(0.3))
                        }
                    }
                }
            }
        }
        .background(.black)
    }

    private var emptyFeed: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "megaphone")
                .font(.system(size: 48))
                .foregroundStyle(.gray)
            Text("No posts yet")
                .font(.title3.weight(.medium))
                .foregroundStyle(.white)
            Text("Be the first to get on the SoapBox!")
                .font(.subheadline)
                .foregroundStyle(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeFeedView()
        .environmentObject(PostStore())
        .preferredColorScheme(.dark)
}
