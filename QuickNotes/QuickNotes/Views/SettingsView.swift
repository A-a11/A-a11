import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var noteStore: NoteStore
    @AppStorage("appAppearance") private var appAppearance = AppAppearance.system
    @State private var showingDeleteConfirmation = false

    enum AppAppearance: String, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"

        var colorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Display") {
                    Picker("Appearance", selection: $appAppearance) {
                        ForEach(AppAppearance.allCases, id: \.self) { appearance in
                            Text(appearance.rawValue).tag(appearance)
                        }
                    }

                    Picker("Sort Order", selection: $noteStore.sortOrder) {
                        ForEach(NoteStore.SortOrder.allCases, id: \.self) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                }

                Section("Statistics") {
                    StatRow(label: "Total Notes", value: "\(noteStore.notes.count)", icon: "note.text")
                    StatRow(label: "Pinned", value: "\(noteStore.notes.filter(\.isPinned).count)", icon: "pin.fill")
                    ForEach(Note.Category.allCases, id: \.self) { category in
                        StatRow(
                            label: category.rawValue,
                            value: "\(noteStore.notes(for: category).count)",
                            icon: category.icon
                        )
                    }
                }

                Section("Data") {
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        Label("Delete All Notes", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Built with")
                        Spacer()
                        Text("SwiftUI")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(appAppearance.colorScheme)
            .alert("Delete All Notes?", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    withAnimation { noteStore.notes.removeAll() }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone. All your notes will be permanently deleted.")
            }
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(NoteStore())
}
