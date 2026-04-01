import SwiftUI

@main
struct SoapBoxApp: App {
    @StateObject private var postStore = PostStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(postStore)
                .preferredColorScheme(.dark)
        }
    }
}
