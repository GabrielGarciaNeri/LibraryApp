import SwiftUI
import SwiftData

struct CategoriesView: View {

    @Query private var items: [LibraryItem]

    let categories = ["Book","Manga","Manhwa","Manhua","Comic"]

    var body: some View {

        NavigationStack {

            List(categories, id: \.self) { category in

                NavigationLink(category) {

                    CategoryDetailView(category: category)
                }
                .listRowBackground(Color.libraryCard)
                .listRowSeparatorTint(Color.libraryStroke)
            }
            .scrollContentBackground(.hidden)
            .background(Color.libraryBackground)
            .navigationTitle("Categories")
        }
    }
}
