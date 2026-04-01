import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var content: String
    var category: Category
    var isPinned: Bool
    var createdAt: Date
    var updatedAt: Date

    enum Category: String, Codable, CaseIterable {
        case personal = "Personal"
        case work = "Work"
        case ideas = "Ideas"
        case tasks = "Tasks"

        var icon: String {
            switch self {
            case .personal: return "person.fill"
            case .work: return "briefcase.fill"
            case .ideas: return "lightbulb.fill"
            case .tasks: return "checklist"
            }
        }

        var color: String {
            switch self {
            case .personal: return "blue"
            case .work: return "orange"
            case .ideas: return "purple"
            case .tasks: return "green"
            }
        }
    }

    init(
        id: UUID = UUID(),
        title: String = "",
        content: String = "",
        category: Category = .personal,
        isPinned: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.isPinned = isPinned
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
