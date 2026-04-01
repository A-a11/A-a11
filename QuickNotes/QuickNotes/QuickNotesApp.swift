import SwiftUI

@main
struct QuickNotesApp: App {
    @StateObject private var noteStore = NoteStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(noteStore)
        }
    }
}
