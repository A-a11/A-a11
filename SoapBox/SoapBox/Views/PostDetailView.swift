import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var postStore: PostStore
    @Environment(\.dismiss) private var dismiss
    let post: Post

    @State private var showCommentRecorder = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Author info
                    HStack(spacing: 8) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.red, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14))
                            )

                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 6) {
                                Text(post.author.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                                Text(post.author.handle)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray)
                            }
                        }

                        Spacer()

                        // Profile circle (right)
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 32, height: 32)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Domain
                    Text(post.domain)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 16)
                        .padding(.top, 2)

                    // Hashtag
                    Text("#\(post.hashtag.replacingOccurrences(of: "#", with: ""))")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color("AccentColor"))
                        .padding(.horizontal, 16)
                        .padding(.top, 1)
                        .padding(.bottom, 6)

                    // Expanded video with vote controls
                    HStack(spacing: 0) {
                        // Video area
                        ZStack {
                            // Video placeholder
                            videoPlaceholder

                            VStack {
                                // Top icons
                                HStack {
                                    // Megaphone
                                    Image(systemName: "megaphone.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(.white.opacity(0.8))
                                        .padding(12)

                                    Spacer()

                                    // Paperclip / attachment
                                    Image(systemName: "paperclip")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white.opacity(0.8))
                                        .rotationEffect(.degrees(-30))
                                        .padding(12)
                                }

                                Spacer()

                                // Left edge peek
                                HStack {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.white.opacity(0.4))
                                        .padding(.leading, 4)
                                    Spacer()
                                }

                                Spacer()

                                // Bottom: timestamp & location
                                HStack {
                                    Text("00:00 PM  \u{2022}  00/00/00")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.7))

                                    Spacer()

                                    Text("city, State")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .padding(.horizontal, 12)
                                .padding(.bottom, 10)
                            }
                        }

                        // Vote controls (right side)
                        VStack(spacing: 14) {
                            Spacer()

                            // Audio
                            Button {
                                postStore.toggleMute(post)
                            } label: {
                                Image(systemName: post.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white.opacity(0.8))
                            }

                            Spacer()

                            // Upvote
                            Button {
                                postStore.upvote(post)
                            } label: {
                                VStack(spacing: 2) {
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 26, weight: .bold))
                                    Text("\(post.upvotes)")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundStyle(post.userVote == .upvoted ? Color("AccentColor") : .white)
                            }

                            // Downvote
                            Button {
                                postStore.downvote(post)
                            } label: {
                                VStack(spacing: 2) {
                                    Text("\(post.downvotes)")
                                        .font(.system(size: 14, weight: .semibold))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 26, weight: .bold))
                                }
                                .foregroundStyle(post.userVote == .downvoted ? .red : .white)
                            }

                            Spacer()
                        }
                        .frame(width: 54)
                        .padding(.vertical, 12)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.58)
                    .padding(.horizontal, 8)

                    // Pink action bar: Likes + Views
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: post.userLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .font(.system(size: 16))
                            Text("\(post.likes)")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Likes")
                                .font(.system(size: 14))
                        }
                        .foregroundStyle(.white)

                        Spacer()

                        HStack(spacing: 6) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 16))
                            Text("\(post.reach)")
                                .font(.system(size: 14, weight: .semibold))
                            Text("views")
                                .font(.system(size: 14))
                        }
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color("AccentColor").opacity(0.35))

                    // Comment matrix header
                    HStack {
                        Text("Responses")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                        Spacer()
                        Text("Touch to listen")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                    // Organic comment matrix
                    CommentMatrixView(postId: post.id)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 100) // space for tab bar
                }
            }

            // Tab bar with "comment" label on +
            detailTabBar
        }
        .background(.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("Post")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color("AccentColor"))
                    Text("Source information")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showCommentRecorder) {
            CommentRecorderView(postId: post.id)
        }
    }

    private var videoPlaceholder: some View {
        let colors: [Color] = {
            switch post.thumbnailColor {
            case "blue": return [.blue.opacity(0.4), .blue.opacity(0.15)]
            case "orange": return [.orange.opacity(0.4), .orange.opacity(0.15)]
            case "purple": return [.purple.opacity(0.4), .purple.opacity(0.15)]
            case "green": return [.green.opacity(0.4), .green.opacity(0.15)]
            case "red": return [.red.opacity(0.4), .red.opacity(0.15)]
            default: return [.gray.opacity(0.4), .gray.opacity(0.15)]
            }
        }()

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var detailTabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house.fill", label: "Home")
            tabItem(icon: "magnifyingglass", label: "Search")

            // Comment button (replaces + / record)
            Button {
                showCommentRecorder = true
            } label: {
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 52, height: 52)
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.black)
                    }
                    .offset(y: -16)
                    Text("comment")
                        .font(.system(size: 10))
                        .foregroundStyle(.white)
                        .offset(y: -14)
                }
            }
            .frame(maxWidth: .infinity)

            tabItem(icon: "square.grid.2x2.fill", label: "Collections")
            tabItem(icon: "bubble.left.and.bubble.right.fill", label: "Message")
        }
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(
            Rectangle()
                .fill(.black)
                .shadow(color: .white.opacity(0.05), radius: 8, y: -4)
        )
    }

    private func tabItem(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(label)
                .font(.system(size: 10))
        }
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        PostDetailView(post: PostStore.samplePosts[0])
            .environmentObject(PostStore())
    }
    .preferredColorScheme(.dark)
}
