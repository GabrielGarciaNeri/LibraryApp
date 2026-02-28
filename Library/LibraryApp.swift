

import SwiftUI
import SwiftData

@main
struct LibraryApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: LibraryItem.self)
    }
}
