import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var handle: String
    var avatarURL: String?
    var bio: String
    var website: String
    var location: String
    var joinedDate: String
    var email: String
    var phone: String
    var birthday: String
    var locationPrivacy: LocationPrivacy
    var subjectsCount: Int
    var followersCount: Int
    var followingCount: Int
    var interestsCount: Int

    enum LocationPrivacy: String, Codable, Hashable {
        case publicVisible = "Public"
        case followersOnly = "Followers Only"
        case doNotShow = "Do Not Show"
    }

    init(
        id: UUID = UUID(),
        name: String,
        handle: String,
        avatarURL: String? = nil,
        bio: String = "",
        website: String = "",
        location: String = "",
        joinedDate: String = "",
        email: String = "",
        phone: String = "",
        birthday: String = "",
        locationPrivacy: LocationPrivacy = .publicVisible,
        subjectsCount: Int = 0,
        followersCount: Int = 0,
        followingCount: Int = 0,
        interestsCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.handle = handle
        self.avatarURL = avatarURL
        self.bio = bio
        self.website = website
        self.location = location
        self.joinedDate = joinedDate
        self.email = email
        self.phone = phone
        self.birthday = birthday
        self.locationPrivacy = locationPrivacy
        self.subjectsCount = subjectsCount
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.interestsCount = interestsCount
    }

    static let currentUser = User(
        name: "You",
        handle: "@namename",
        bio: "Lorem ipsum @dolor sit amet, consectetur.\n#BIOS#Soapbox#Snapchat#Twitter#Reddit",
        website: "https://ffish.jp",
        location: "City, State/Country",
        joinedDate: "joined month 0000",
        email: "",
        phone: "(000) 000-000",
        birthday: "00 / 00 / 0000",
        locationPrivacy: .publicVisible,
        subjectsCount: 100,
        followersCount: 8,
        followingCount: 37,
        interestsCount: 100
    )

    static let sampleUsers: [User] = [
        User(name: "Marcus", handle: "@marcus_j", followersCount: 88, followingCount: 87, interestsCount: 45),
        User(name: "Aaliyah", handle: "@aaliyah_w", followersCount: 120, followingCount: 87, interestsCount: 62),
        User(name: "Devon", handle: "@dev_thinks", followersCount: 340, followingCount: 87, interestsCount: 38),
        User(name: "Keisha", handle: "@keisha_m", followersCount: 56, followingCount: 87, interestsCount: 71),
        User(name: "Jordan", handle: "@j_speaks", followersCount: 215, followingCount: 87, interestsCount: 53),
        User(name: "Taylor", handle: "@tay_real", followersCount: 92, followingCount: 87, interestsCount: 44),
        User(name: "Andre", handle: "@dre_daily", followersCount: 178, followingCount: 87, interestsCount: 29),
        User(name: "Simone", handle: "@simone_v", followersCount: 64, followingCount: 87, interestsCount: 81),
        User(name: "Chris", handle: "@chris_box", followersCount: 410, followingCount: 87, interestsCount: 55),
        User(name: "Maya", handle: "@maya_speaks", followersCount: 33, followingCount: 87, interestsCount: 67),
    ]
}
