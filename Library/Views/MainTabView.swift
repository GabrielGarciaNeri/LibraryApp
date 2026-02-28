import SwiftUI

struct MainTabView: View {

    var body: some View {

        TabView {

            // Library Tab
            HomeView()
                .id(UUID())
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
            // Category Tab
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }

            // Favorites Tab
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}


