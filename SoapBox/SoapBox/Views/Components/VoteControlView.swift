import SwiftUI

struct VoteControlView: View {
    let post: Post
    let onUpvote: () -> Void
    let onDownvote: () -> Void
    let onMute: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            // Audio toggle
            Button(action: onMute) {
                Image(systemName: post.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()

            // Upvote
            Button(action: onUpvote) {
                VStack(spacing: 2) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(post.userVote == .upvoted ? Color("AccentColor") : .white)

                    Text(formattedCount(post.upvotes))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(post.userVote == .upvoted ? Color("AccentColor") : .white)
                }
            }

            // Downvote
            Button(action: onDownvote) {
                VStack(spacing: 2) {
                    Text(formattedCount(post.downvotes))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(post.userVote == .downvoted ? .red : .white)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(post.userVote == .downvoted ? .red : .white)
                }
            }

            Spacer()
        }
        .padding(.vertical, 12)
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
    ZStack {
        Color.black
        VoteControlView(
            post: PostStore.samplePosts[0],
            onUpvote: {},
            onDownvote: {},
            onMute: {}
        )
        .frame(width: 50)
    }
    .preferredColorScheme(.dark)
}
