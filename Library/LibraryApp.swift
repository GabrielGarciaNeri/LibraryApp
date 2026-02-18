

import SwiftUI
import SwiftData

@main
struct LibraryApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: LibraryItem.self)
    }
}
