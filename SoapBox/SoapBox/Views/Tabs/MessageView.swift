import SwiftUI

struct MessageView: View {
    @State private var searchText = ""

    private let sampleConversations: [(User, String, String)] = [
        (User.sampleUsers[0], "Did you see that parking video?", "2m ago"),
        (User.sampleUsers[1], "The pothole on Main St is insane", "15m ago"),
        (User.sampleUsers[2], "Great point about the city council", "1h ago"),
        (User.sampleUsers[3], "That deer video was amazing!", "3h ago"),
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sampleConversations, id: \.0.id) { user, message, time in
                    HStack(spacing: 12) {
                        // Avatar
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(user.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                                Text(time)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            Text(message)
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                    }
                    .listRowBackground(Color(.systemGray6).opacity(0.15))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(.black)
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search messages...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // New message
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(Color("AccentColor"))
                    }
                }
            }
        }
    }
}

#Preview {
    MessageView()
        .preferredColorScheme(.dark)
}
