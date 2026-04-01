import Foundation
import SwiftUI

class NoteStore: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet { save() }
    }

    @AppStorage("sortOrder") var sortOrder: SortOrder = .dateNewest

    enum SortOrder: String, CaseIterable {
        case dateNewest = "Newest First"
        case dateOldest = "Oldest First"
        case titleAZ = "Title A-Z"
        case titleZA = "Title Z-A"
    }

    private let saveKey = "QuickNotes_SavedNotes"

    init() {
        load()
        if notes.isEmpty {
            notes = Self.sampleNotes
        }
    }

    var sortedNotes: [Note] {
        let pinned = notes.filter { $0.isPinned }
        let unpinned = notes.filter { !$0.isPinned }
        return pinned.sorted(by: sortComparator) + unpinned.sorted(by: sortComparator)
    }

    func notes(for category: Note.Category) -> [Note] {
        sortedNotes.filter { $0.category == category }
    }

    func search(_ query: String) -> [Note] {
        guard !query.isEmpty else { return sortedNotes }
        let lowered = query.lowercased()
        return sortedNotes.filter {
            $0.title.lowercased().contains(lowered) ||
            $0.content.lowercased().contains(lowered)
        }
    }

    func add(_ note: Note) {
        notes.append(note)
    }

    func update(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updated = note
            updated.updatedAt = Date()
            notes[index] = updated
        }
    }

    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
    }

    func togglePin(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isPinned.toggle()
        }
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }

    private var sortComparator: (Note, Note) -> Bool {
        switch sortOrder {
        case .dateNewest: return { $0.updatedAt > $1.updatedAt }
        case .dateOldest: return { $0.updatedAt < $1.updatedAt }
        case .titleAZ: return { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .titleZA: return { $0.title.localizedCompare($1.title) == .orderedDescending }
        }
    }

    // MARK: - Sample Data

    static var sampleNotes: [Note] {
        [
            Note(
                title: "Welcome to QuickNotes!",
                content: "This is your first note. Tap to edit it, or create a new one with the + button.\n\nYou can organize notes by category, pin important ones, and search through everything.",
                category: .personal,
                isPinned: true
            ),
            Note(
                title: "Project Ideas",
                content: "- Build a weather dashboard\n- Create a recipe organizer\n- Design a fitness tracker\n- Make a budget planner",
                category: .ideas
            ),
            Note(
                title: "Weekly Tasks",
                content: "- Review pull requests\n- Update documentation\n- Team standup notes\n- Plan sprint goals",
                category: .tasks
            ),
            Note(
                title: "Meeting Notes",
                content: "Discussed Q2 roadmap priorities.\nKey decisions:\n1. Focus on mobile-first\n2. Improve onboarding flow\n3. Add analytics dashboard",
                category: .work
            ),
        ]
    }
}
