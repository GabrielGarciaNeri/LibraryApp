import SwiftUI
import SwiftData

struct CategoryDetailView: View {

    let category: String
    @Query private var items: [LibraryItem]

    var filtered: [LibraryItem] {
        items.filter { $0.category == category }
    }

    var body: some View {

        List(filtered) { item in
            Text(item.title)
        }
        .navigationTitle(category)
    }
}

