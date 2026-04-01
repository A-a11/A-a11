import SwiftUI

struct FeedHeaderView: View {
    @EnvironmentObject var postStore: PostStore
    let avatarAction: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                // Profile avatar
                Button(action: avatarAction) {
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
                                .font(.system(size: 18))
                        )
                }

                Spacer()

                // App title
                Text("SoapBox")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("AccentColor"))

                Spacer()

                // Placeholder for symmetry
                Circle()
                    .fill(.clear)
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal)

            // Home | World toggle
            HStack(spacing: 0) {
                ForEach(Post.FeedType.allCases, id: \.self) { feed in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            postStore.selectedFeed = feed
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Text(feed.rawValue)
                                .font(.system(size: 16, weight: postStore.selectedFeed == feed ? .bold : .regular))
                                .foregroundStyle(postStore.selectedFeed == feed ? .white : .gray)

                            Rectangle()
                                .fill(postStore.selectedFeed == feed ? Color("AccentColor") : .clear)
                                .frame(height: 2)
                        }
                    }

                    if feed == .home {
                        Text("|")
                            .foregroundStyle(.gray.opacity(0.5))
                            .padding(.horizontal, 12)
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.top, 8)
        .background(.black)
    }
}

#Preview {
    FeedHeaderView(avatarAction: {})
        .environmentObject(PostStore())
        .preferredColorScheme(.dark)
}
