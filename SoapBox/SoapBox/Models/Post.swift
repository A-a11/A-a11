import Foundation

struct Post: Identifiable, Codable {
    var id: UUID
    var author: User
    var domain: String
    var hashtag: String
    var videoURL: String?
    var thumbnailColor: String
    var upvotes: Int
    var downvotes: Int
    var likes: Int
    var reposts: Int
    var viewers: Int
    var reach: Int
    var isMuted: Bool
    var isBookmarked: Bool
    var userVote: VoteState
    var userLiked: Bool
    var userReposted: Bool
    var sourceInfo: String
    var createdAt: Date
    var feedType: FeedType

    enum VoteState: String, Codable {
        case none
        case upvoted
        case downvoted
    }

    enum FeedType: String, Codable, CaseIterable {
        case home = "Home"
        case world = "World"
    }

    init(
        id: UUID = UUID(),
        author: User,
        domain: String,
        hashtag: String,
        videoURL: String? = nil,
        thumbnailColor: String = "gray",
        upvotes: Int = 0,
        downvotes: Int = 0,
        likes: Int = 0,
        reposts: Int = 0,
        viewers: Int = 0,
        reach: Int = 0,
        isMuted: Bool = false,
        isBookmarked: Bool = false,
        userVote: VoteState = .none,
        userLiked: Bool = false,
        userReposted: Bool = false,
        sourceInfo: String = "",
        createdAt: Date = Date(),
        feedType: FeedType = .home
    ) {
        self.id = id
        self.author = author
        self.domain = domain
        self.hashtag = hashtag
        self.videoURL = videoURL
        self.thumbnailColor = thumbnailColor
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.likes = likes
        self.reposts = reposts
        self.viewers = viewers
        self.reach = reach
        self.isMuted = isMuted
        self.isBookmarked = isBookmarked
        self.userVote = userVote
        self.userLiked = userLiked
        self.userReposted = userReposted
        self.sourceInfo = sourceInfo
        self.createdAt = createdAt
        self.feedType = feedType
    }

    var score: Int { upvotes - downvotes }
}
