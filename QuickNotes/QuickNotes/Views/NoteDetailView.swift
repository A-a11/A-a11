import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss

    let note: Note
    @State private var isEditing = false

    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: note.category.icon)
                        Text(note.category.rawValue)
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundStyle(categoryColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(categoryColor.opacity(0.1))
                    .clipShape(Capsule())

                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.title.weight(.bold))

                    HStack(spacing: 16) {
                        Label(timeFormatter.string(from: note.createdAt), systemImage: "calendar")
                        if note.createdAt != note.updatedAt {
                            Label("Edited \(timeFormatter.string(from: note.updatedAt))", systemImage: "pencil")
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Divider()

                // Content
                if note.content.isEmpty {
                    Text("No content")
                        .foregroundStyle(.tertiary)
                        .italic()
                } else {
                    Text(note.content)
                        .font(.body)
                        .lineSpacing(4)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    noteStore.togglePin(note)
                } label: {
                    Image(systemName: note.isPinned ? "pin.slash" : "pin")
                }

                Button {
                    isEditing = true
                } label: {
                    Image(systemName: "pencil.circle")
                }

                Menu {
                    Button(role: .destructive) {
                        noteStore.delete(note)
                        dismiss()
                    } label: {
                        Label("Delete Note", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NoteEditorView(note: note, isEditing: true)
        }
    }

    private var categoryColor: Color {
        switch note.category {
        case .personal: return .blue
        case .work: return .orange
        case .ideas: return .purple
        case .tasks: return .green
        }
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: NoteStore.sampleNotes[0])
            .environmentObject(NoteStore())
    }
}
