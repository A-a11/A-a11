import SwiftUI

struct ContentView: View {
    @EnvironmentObject var noteStore: NoteStore

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .tint(.accentColor)
    }
}

#Preview {
    ContentView()
        .environmentObject(NoteStore())
}
