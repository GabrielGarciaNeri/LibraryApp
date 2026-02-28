import SwiftUI
import SwiftData

struct FavoritesView: View {

    @Environment(\.modelContext) private var context

    @Query(filter: #Predicate<LibraryItem> { $0.isFavorite })
    private var favorites: [LibraryItem]

    @State private var showGrid = true
    @State private var searchText = ""
    @State private var selectedItem: LibraryItem?

    var filteredFavorites: [LibraryItem] {
        favorites.filter {
            searchText.isEmpty ||
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.author.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {

        NavigationStack {

            Group {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet ⭐",
                        systemImage: "star",
                        description: Text("Mark items as favorite to see them here.")
                    )
                } else {
                    Group {
                        if showGrid {
                            LibraryGridView(
                                items: filteredFavorites,
                                selectedItem: $selectedItem,
                                pendingDeleteID: .constant(nil),
                                isEditing: .constant(false)
                            )
                        } else {
                            LibraryListView(
                                items: filteredFavorites,
                                selectedItem: $selectedItem
                            )
                        }
                    }

//                    Group {
//                        if showGrid {
//                            gridView
//                        } else {
//                            listView
//                        }
//                    }
                }
            }
            .navigationTitle("Favorites ⭐")
            .toolbar {
                Button {
                    showGrid.toggle()
                } label: {
                    Image(systemName:
                        showGrid
                        ? "list.bullet"
                        : "square.grid.2x2")
                }
            }
            .searchable(text: $searchText)
            .navigationDestination(item: $selectedItem) {
                ItemDetailView(item: $0)
            }
        }
    }

//    var listView: some View {
//        List(filteredFavorites) { item in
//
//            VStack(alignment: .leading, spacing: 6) {
//
//                HStack {
//                    Text(item.title).font(.headline)
//
//                    Spacer()
//
//                    Button {
//                        item.isFavorite.toggle()
//                    } label: {
//                        Image(systemName:"star.fill")
//                            .foregroundStyle(.yellow)
//                    }
//                }
//
//                Text(item.author)
//                    .foregroundColor(.gray)
//
//                ProgressBarView(
//                    current: item.currentProgress,
//                    total: item.totalCount
//                )
//            }
//            .contentShape(Rectangle())
//            .onTapGesture {
//                selectedItem = item
//            }
//        }
//    }
//
//    var gridView: some View {
//
//        ScrollView {
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))]) {
//
//                ForEach(filteredFavorites) { item in
//
//                    VStack(spacing: 8) {
//
//                        Image(systemName:"book.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height:70)
//
//                        Text(item.title)
//                            .font(.headline)
//                            .lineLimit(2)
//
//                        Text(item.author)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//
//                        ProgressBarView(
//                            current: item.currentProgress,
//                            total: item.totalCount
//                        )
//                    }
//                    .frame(width:150,height:190)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(14)
//                    .onTapGesture {
//                        selectedItem = item
//                    }
//                }
//            }
//            .padding()
//        }
//    }
}


