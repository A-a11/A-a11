import SwiftUI

struct SearchView: View {
    @EnvironmentObject var postStore: PostStore
    @State private var searchText = ""

    private var filteredPosts: [Post] {
        guard !searchText.isEmpty else { return postStore.posts }
        let lowered = searchText.lowercased()
        return postStore.posts.filter {
            $0.domain.lowercased().contains(lowered) ||
            $0.hashtag.lowercased().contains(lowered) ||
            $0.author.name.lowercased().contains(lowered) ||
            $0.author.handle.lowercased().contains(lowered)
        }
    }

    private let trendingTopics = [
        ("#parkingproblems", "Automotive"),
        ("#fixourroads", "Infrastructure"),
        ("#shrinkflation", "Consumer Rights"),
        ("#citycouncil", "Local Government"),
        ("#urbanwildlife", "Environment"),
        ("#publictransit", "Transportation"),
        ("#neighborhoodwatch", "Community"),
        ("#schoolboard", "Education"),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if searchText.isEmpty {
                    trendingSection
                } else {
                    searchResults
                }
            }
            .background(.black)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search topics, hashtags, people...")
        }
    }

    private var trendingSection: some View {
        List {
            Section {
                ForEach(trendingTopics, id: \.0) { topic, domain in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(topic)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("AccentColor"))
                            Text(domain)
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .listRowBackground(Color(.systemGray6).opacity(0.15))
                }
            } header: {
                Text("Trending Topics")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .textCase(nil)
            }
        }
        .listStyle(.grouped)
        .scrollContentBackground(.hidden)
    }

    private var searchResults: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if filteredPosts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 36))
                            .foregroundStyle(.gray)
                        Text("No results for \"\(searchText)\"")
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 60)
                } else {
                    ForEach(filteredPosts) { post in
                        PostCardView(post: post)
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(PostStore())
        .preferredColorScheme(.dark)
}
