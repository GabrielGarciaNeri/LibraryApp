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
            }
            .navigationTitle("Categories")
        }
    }
}

