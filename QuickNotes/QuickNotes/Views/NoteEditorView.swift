import SwiftUI

struct NoteEditorView: View {
    @EnvironmentObject var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss

    @State var note: Note
    var isEditing: Bool = false

    @FocusState private var titleFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Note title", text: $note.title)
                        .font(.headline)
                        .focused($titleFocused)
                }

                Section("Category") {
                    Picker("Category", selection: $note.category) {
                        ForEach(Note.Category.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Content") {
                    TextEditor(text: $note.content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle(isEditing ? "Edit Note" : "New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if isEditing {
                            noteStore.update(note)
                        } else {
                            noteStore.add(note)
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(note.title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if !isEditing {
                    titleFocused = true
                }
            }
        }
    }
}

#Preview {
    NoteEditorView(note: Note())
        .environmentObject(NoteStore())
}
