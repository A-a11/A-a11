import SwiftUI

struct PostActionsBar: View {
    let post: Post
    let onLike: () -> Void
    let onRepost: () -> Void

    var body: some View {
        HStack {
            // Like
            Button(action: onLike) {
                HStack(spacing: 4) {
                    Image(systemName: post.userLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.system(size: 18))
                    Text(formattedCount(post.likes))
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(post.userLiked ? Color("AccentColor") : .white)
            }

            Spacer()

            // Repost
            Button(action: onRepost) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.system(size: 18))
                    Text(formattedCount(post.reposts))
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(post.userReposted ? .green : .white)
            }

            Spacer()

            // Viewers
            HStack(spacing: 4) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 16))
                Text(formattedCount(post.viewers))
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.7))

            Spacer()

            // Reach / analytics
            HStack(spacing: 4) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 16))
                Text(formattedCount(post.reach))
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func formattedCount(_ count: Int) -> String {
        if count >= 1000 {
            let k = Double(count) / 1000.0
            return String(format: "%.1fk", k)
        }
        return "\(count)"
    }
}

#Preview {
    PostActionsBar(
        post: PostStore.samplePosts[0],
        onLike: {},
        onRepost: {}
    )
    .background(.black)
    .preferredColorScheme(.dark)
}
