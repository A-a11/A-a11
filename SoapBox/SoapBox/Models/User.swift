import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var handle: String
    var avatarURL: String?

    init(
        id: UUID = UUID(),
        name: String,
        handle: String,
        avatarURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.handle = handle
        self.avatarURL = avatarURL
    }

    static let currentUser = User(name: "You", handle: "@you")

    static let sampleUsers: [User] = [
        User(name: "Marcus", handle: "@marcus_j"),
        User(name: "Aaliyah", handle: "@aaliyah_w"),
        User(name: "Devon", handle: "@dev_thinks"),
        User(name: "Keisha", handle: "@keisha_m"),
        User(name: "Jordan", handle: "@j_speaks"),
    ]
}
