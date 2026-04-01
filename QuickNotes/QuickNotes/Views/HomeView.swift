import SwiftUI

struct HomeView: View {
    @EnvironmentObject var noteStore: NoteStore
    @State private var searchText = ""
    @State private var selectedCategory: Note.Category?
    @State private var showingNewNote = false

    private var displayedNotes: [Note] {
        let filtered = selectedCategory != nil
            ? noteStore.notes(for: selectedCategory!)
            : noteStore.sortedNotes
        if searchText.isEmpty {
            return filtered
        }
        let lowered = searchText.lowercased()
        return filtered.filter {
            $0.title.lowercased().contains(lowered) ||
            $0.content.lowercased().contains(lowered)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryChip(
                            title: "All",
                            icon: "tray.fill",
                            isSelected: selectedCategory == nil,
                            color: .accentColor
                        ) {
                            withAnimation { selectedCategory = nil }
                        }

                        ForEach(Note.Category.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: selectedCategory == category,
                                color: categoryColor(category)
                            ) {
                                withAnimation {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                if displayedNotes.isEmpty {
                    emptyState
                } else {
                    notesList
                }
            }
            .navigationTitle("QuickNotes")
            .searchable(text: $searchText, prompt: "Search notes...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewNote = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NoteEditorView(note: Note(category: selectedCategory ?? .personal))
            }
        }
    }

    private var notesList: some View {
        List {
            ForEach(displayedNotes) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    NoteRow(note: note)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        withAnimation { noteStore.delete(note) }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        withAnimation { noteStore.togglePin(note) }
                    } label: {
                        Label(
                            note.isPinned ? "Unpin" : "Pin",
                            systemImage: note.isPinned ? "pin.slash" : "pin"
                        )
                    }
                    .tint(.orange)
                }
            }
        }
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: searchText.isEmpty ? "note.text" : "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(searchText.isEmpty ? "No notes yet" : "No results found")
                .font(.title3.weight(.medium))
            Text(searchText.isEmpty
                 ? "Tap + to create your first note"
                 : "Try a different search term")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func categoryColor(_ category: Note.Category) -> Color {
        switch category {
        case .personal: return .blue
        case .work: return .orange
        case .ideas: return .purple
        case .tasks: return .green
        }
    }
}

// MARK: - Supporting Views

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.15) : Color(.systemGray6))
            .foregroundStyle(isSelected ? color : .secondary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? color.opacity(0.3) : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct NoteRow: View {
    let note: Note

    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: note.updatedAt, relativeTo: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(timeAgo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !note.content.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 4) {
                Image(systemName: note.category.icon)
                    .font(.caption2)
                Text(note.category.rawValue)
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HomeView()
        .environmentObject(NoteStore())
}
