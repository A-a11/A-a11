import SwiftUI
import AVFoundation

struct VideoComment: Identifiable {
    let id: UUID
    let author: User
    let thumbnailColor: String
    let duration: TimeInterval
    let timeAgo: String
    let size: CGFloat // Organic sizing

    static func samples(for postId: UUID) -> [VideoComment] {
        let users = User.sampleUsers
        return [
            VideoComment(id: UUID(), author: users[0], thumbnailColor: "blue", duration: 12, timeAgo: "2m", size: 1.0),
            VideoComment(id: UUID(), author: users[1], thumbnailColor: "purple", duration: 8, timeAgo: "5m", size: 0.7),
            VideoComment(id: UUID(), author: users[2], thumbnailColor: "orange", duration: 23, timeAgo: "11m", size: 1.2),
            VideoComment(id: UUID(), author: users[3], thumbnailColor: "green", duration: 5, timeAgo: "14m", size: 0.6),
            VideoComment(id: UUID(), author: users[4], thumbnailColor: "red", duration: 18, timeAgo: "20m", size: 0.9),
            VideoComment(id: UUID(), author: users[0], thumbnailColor: "orange", duration: 31, timeAgo: "25m", size: 1.1),
            VideoComment(id: UUID(), author: users[1], thumbnailColor: "blue", duration: 9, timeAgo: "30m", size: 0.8),
            VideoComment(id: UUID(), author: users[3], thumbnailColor: "purple", duration: 15, timeAgo: "45m", size: 1.0),
            VideoComment(id: UUID(), author: users[2], thumbnailColor: "green", duration: 7, timeAgo: "1h", size: 0.65),
            VideoComment(id: UUID(), author: users[4], thumbnailColor: "red", duration: 20, timeAgo: "1h", size: 0.85),
            VideoComment(id: UUID(), author: users[0], thumbnailColor: "blue", duration: 11, timeAgo: "2h", size: 0.75),
            VideoComment(id: UUID(), author: users[1], thumbnailColor: "orange", duration: 14, timeAgo: "2h", size: 1.05),
        ]
    }
}

struct CommentMatrixView: View {
    let postId: UUID

    @State private var comments: [VideoComment] = []
    @State private var activeCommentId: UUID?
    @State private var touchVolume: CGFloat = 0
    @State private var touchLocation: CGPoint = .zero
    @State private var isPlaying = false

    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Volume indicator bar
            if isPlaying {
                HStack(spacing: 4) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color("AccentColor"))

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(.systemGray5))
                                .frame(height: 4)
                            Capsule()
                                .fill(Color("AccentColor"))
                                .frame(width: geo.size.width * touchVolume, height: 4)
                        }
                    }
                    .frame(height: 4)

                    Text("\(Int(touchVolume * 100))%")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(.gray)
                        .frame(width: 36)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6).opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.bottom, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Organic grid matrix
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(comments) { comment in
                    CommentBubble(
                        comment: comment,
                        isActive: activeCommentId == comment.id
                    )
                    .frame(height: 80 * comment.size)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        touchLocation = value.location
                        handleTouch(at: value.location)
                    }
                    .onEnded { _ in
                        withAnimation(.easeOut(duration: 0.3)) {
                            activeCommentId = nil
                            isPlaying = false
                        }
                    }
            )
        }
        .onAppear {
            comments = VideoComment.samples(for: postId)
        }
    }

    private func handleTouch(at point: CGPoint) {
        // Calculate which comment is being touched based on grid position
        let columnWidth = (UIScreen.main.bounds.width - 32) / 3
        let col = min(2, max(0, Int(point.x / columnWidth)))

        // Estimate row from y position
        var yOffset: CGFloat = 0
        var targetIndex: Int?

        for (index, comment) in comments.enumerated() {
            let row = index / 3
            let commentCol = index % 3

            if commentCol == 0 {
                if row > 0 {
                    // Approximate row height from previous row's max size
                    let rowStart = (row - 1) * 3
                    let rowEnd = min(rowStart + 3, comments.count)
                    let maxSize = comments[rowStart..<rowEnd].map(\.size).max() ?? 1.0
                    yOffset += 80 * maxSize + 6
                }
            }

            if commentCol == col && point.y >= yOffset && point.y < yOffset + 80 * comment.size + 6 {
                targetIndex = index
                break
            }
        }

        if let idx = targetIndex, idx < comments.count {
            let comment = comments[idx]
            if activeCommentId != comment.id {
                withAnimation(.easeInOut(duration: 0.15)) {
                    activeCommentId = comment.id
                    isPlaying = true
                }
                // Haptic feedback when switching comments
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            }

            // Volume based on vertical finger position within the comment bubble
            // Higher on the bubble = louder
            let relativeY = point.y - yOffset
            let bubbleHeight = 80 * comment.size
            let volumeRatio = 1.0 - (relativeY / bubbleHeight)
            withAnimation(.easeOut(duration: 0.1)) {
                touchVolume = min(1.0, max(0.05, volumeRatio))
            }
        }
    }
}

struct CommentBubble: View {
    let comment: VideoComment
    let isActive: Bool

    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: 10)
                .fill(bubbleGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            isActive ? Color("AccentColor") : .clear,
                            lineWidth: 2
                        )
                )

            VStack(spacing: 4) {
                // Play indicator
                if isActive {
                    Image(systemName: "waveform")
                        .font(.system(size: 18))
                        .foregroundStyle(Color("AccentColor"))
                        .symbolEffect(.variableColor.iterative, isActive: isActive)
                } else {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.6))
                }

                // Author name
                Text(comment.author.name)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                // Duration + time
                HStack(spacing: 2) {
                    Text(formatDuration(comment.duration))
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                    Text("\u{2022}")
                        .font(.system(size: 6))
                    Text(comment.timeAgo)
                        .font(.system(size: 9))
                }
                .foregroundStyle(.white.opacity(0.5))
            }
        }
        .scaleEffect(isActive ? 1.05 : 1.0)
        .shadow(
            color: isActive ? Color("AccentColor").opacity(0.4) : .clear,
            radius: 8
        )
        .animation(.easeInOut(duration: 0.15), value: isActive)
    }

    private var bubbleGradient: LinearGradient {
        let colors: [Color] = {
            switch comment.thumbnailColor {
            case "blue": return [.blue.opacity(0.35), .blue.opacity(0.15)]
            case "purple": return [.purple.opacity(0.35), .purple.opacity(0.15)]
            case "orange": return [.orange.opacity(0.35), .orange.opacity(0.15)]
            case "green": return [.green.opacity(0.35), .green.opacity(0.15)]
            case "red": return [.red.opacity(0.35), .red.opacity(0.15)]
            default: return [.gray.opacity(0.35), .gray.opacity(0.15)]
            }
        }()

        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let s = Int(seconds)
        return String(format: "0:%02d", s)
    }
}

#Preview {
    ScrollView {
        CommentMatrixView(postId: UUID())
            .padding()
    }
    .background(.black)
    .preferredColorScheme(.dark)
}
