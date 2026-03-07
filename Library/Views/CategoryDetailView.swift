import SwiftUI
import SwiftData

struct CategoryDetailView: View {

    let category: String
    @Query private var items: [LibraryItem]

    var filtered: [LibraryItem] {
        items
            .filter { $0.category == category }
            .sorted { lhs, rhs in
                let titleCompare = lhs.title.localizedCaseInsensitiveCompare(rhs.title)
                if titleCompare == .orderedSame {
                    return lhs.author.localizedCaseInsensitiveCompare(rhs.author) == .orderedAscending
                }
                return titleCompare == .orderedAscending
            }
    }

    var body: some View {

        List(filtered) { item in
            Text(item.title)
                .listRowBackground(Color.libraryCard)
                .listRowSeparatorTint(Color.libraryStroke)
        }
        .scrollContentBackground(.hidden)
        .background(Color.libraryBackground)
        .navigationTitle(category)
    }
}
