import Foundation
import SwiftUI

class PostStore: ObservableObject {
    @Published var posts: [Post] = []
    @Published var selectedFeed: Post.FeedType = .home

    init() {
        posts = Self.samplePosts
    }

    var feedPosts: [Post] {
        posts
            .filter { $0.feedType == selectedFeed }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func upvote(_ post: Post) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        if posts[idx].userVote == .upvoted {
            posts[idx].upvotes -= 1
            posts[idx].userVote = .none
        } else {
            if posts[idx].userVote == .downvoted {
                posts[idx].downvotes -= 1
            }
            posts[idx].upvotes += 1
            posts[idx].userVote = .upvoted
        }
    }

    func downvote(_ post: Post) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        if posts[idx].userVote == .downvoted {
            posts[idx].downvotes -= 1
            posts[idx].userVote = .none
        } else {
            if posts[idx].userVote == .upvoted {
                posts[idx].upvotes -= 1
            }
            posts[idx].downvotes += 1
            posts[idx].userVote = .downvoted
        }
    }

    func toggleLike(_ post: Post) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[idx].userLiked.toggle()
        posts[idx].likes += posts[idx].userLiked ? 1 : -1
    }

    func toggleRepost(_ post: Post) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[idx].userReposted.toggle()
        posts[idx].reposts += posts[idx].userReposted ? 1 : -1
    }

    func toggleBookmark(_ post: Post) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[idx].isBookmarked.toggle()
    }

    func toggleMute(_ post: Post) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[idx].isMuted.toggle()
    }

    func addPost(_ post: Post) {
        posts.insert(post, at: 0)
    }

    // MARK: - Sample Data

    static var samplePosts: [Post] {
        let users = User.sampleUsers
        return [
            Post(
                author: users[0],
                domain: "Automotive/Road Safety",
                hashtag: "#parkingproblems",
                thumbnailColor: "blue",
                upvotes: 274,
                downvotes: 57,
                likes: 900,
                reposts: 652,
                viewers: 27,
                reach: 100,
                sourceInfo: "Filmed at Maple St & 5th Ave",
                feedType: .home
            ),
            Post(
                author: users[1],
                domain: "Community/Infrastructure",
                hashtag: "#fixourroads",
                thumbnailColor: "orange",
                upvotes: 1203,
                downvotes: 89,
                likes: 2400,
                reposts: 1100,
                viewers: 156,
                reach: 500,
                sourceInfo: "Downtown pothole on Main Street",
                feedType: .home
            ),
            Post(
                author: users[2],
                domain: "Politics/Local Government",
                hashtag: "#citycouncil",
                thumbnailColor: "purple",
                upvotes: 532,
                downvotes: 201,
                likes: 780,
                reposts: 345,
                viewers: 89,
                reach: 250,
                sourceInfo: "City Hall public hearing",
                feedType: .world
            ),
            Post(
                author: users[3],
                domain: "Environment/Wildlife",
                hashtag: "#urbanwildlife",
                thumbnailColor: "green",
                upvotes: 3400,
                downvotes: 12,
                likes: 5600,
                reposts: 2300,
                viewers: 412,
                reach: 1200,
                sourceInfo: "Backyard in suburban Dallas",
                feedType: .world
            ),
            Post(
                author: users[4],
                domain: "Food/Consumer Rights",
                hashtag: "#shrinkflation",
                thumbnailColor: "red",
                upvotes: 891,
                downvotes: 34,
                likes: 1500,
                reposts: 890,
                viewers: 67,
                reach: 340,
                sourceInfo: "Local grocery store comparison",
                feedType: .home
            ),
        ]
    }
}
