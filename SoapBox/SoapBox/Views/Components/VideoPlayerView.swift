import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let post: Post
    let onBookmark: () -> Void
    let onMute: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Thumbnail placeholder (gradient based on post color)
                thumbnailGradient
                    .frame(width: geo.size.width, height: geo.size.height)

                // Megaphone icon (top-left)
                VStack {
                    HStack {
                        Image(systemName: "megaphone.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(12)
                        Spacer()

                        // Bookmark (top-right)
                        Button(action: onBookmark) {
                            Image(systemName: post.isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 18))
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(12)
                        }
                    }
                    Spacer()
                }

                // Play button overlay
                Image(systemName: "play.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.white.opacity(0.7))

                // Previous post peek (left edge)
                HStack {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.leading, 4)
                    Spacer()
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var thumbnailGradient: some View {
        let colors: [Color] = {
            switch post.thumbnailColor {
            case "blue": return [.blue.opacity(0.4), .blue.opacity(0.2)]
            case "orange": return [.orange.opacity(0.4), .orange.opacity(0.2)]
            case "purple": return [.purple.opacity(0.4), .purple.opacity(0.2)]
            case "green": return [.green.opacity(0.4), .green.opacity(0.2)]
            case "red": return [.red.opacity(0.4), .red.opacity(0.2)]
            default: return [.gray.opacity(0.4), .gray.opacity(0.2)]
            }
        }()

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    VideoPlayerView(
        post: PostStore.samplePosts[0],
        onBookmark: {},
        onMute: {}
    )
    .frame(height: 400)
    .preferredColorScheme(.dark)
}
