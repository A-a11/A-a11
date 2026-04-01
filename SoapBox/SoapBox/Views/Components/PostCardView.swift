import SwiftUI

struct PostCardView: View {
    @EnvironmentObject var postStore: PostStore
    let post: Post

    var body: some View {
        NavigationLink(destination: PostDetailView(post: post)) {
        VStack(alignment: .leading, spacing: 0) {
            // Author info
            HStack(spacing: 8) {
                // Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                    )

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 6) {
                        Text(post.author.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                        Text(post.author.handle)
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)

            // Domain / topic
            Text(post.domain)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 16)
                .padding(.top, 2)

            // Hashtag
            Text("#\(post.hashtag.replacingOccurrences(of: "#", with: ""))")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color("AccentColor"))
                .padding(.horizontal, 16)
                .padding(.top, 1)
                .padding(.bottom, 8)

            // Video area with vote controls overlaid on right side
            HStack(spacing: 0) {
                VideoPlayerView(
                    post: post,
                    onBookmark: { postStore.toggleBookmark(post) },
                    onMute: { postStore.toggleMute(post) }
                )

                // Vote controls on the right edge
                VoteControlView(
                    post: post,
                    onUpvote: { postStore.upvote(post) },
                    onDownvote: { postStore.downvote(post) },
                    onMute: { postStore.toggleMute(post) }
                )
                .frame(width: 50)
            }
            .frame(height: UIScreen.main.bounds.height * 0.52)
            .padding(.horizontal, 12)

            // Action bar (like, repost, viewers, reach)
            PostActionsBar(
                post: post,
                onLike: { postStore.toggleLike(post) },
                onRepost: { postStore.toggleRepost(post) }
            )

            // Source information bar
            HStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 10))
                    )

                Spacer()

                Text("Source information")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)

                Spacer()

                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 28, height: 28)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(.black)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScrollView {
        PostCardView(post: PostStore.samplePosts[0])
            .environmentObject(PostStore())
    }
    .background(.black)
    .preferredColorScheme(.dark)
}
