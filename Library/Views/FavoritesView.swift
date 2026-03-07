import SwiftUI
import SwiftData

struct FavoritesView: View {

    enum FavoritesMode {
        case normal
        case searching
    }

    enum SortOption: String, CaseIterable {
        case titleAZ = "Title A-Z"
        case titleZA = "Title Z-A"
        case authorAZ = "Author A-Z"
        case authorZA = "Author Z-A"
        case progressLowHigh = "Progress Low-High"
        case progressHighLow = "Progress High-Low"
    }

    @Query(filter: #Predicate<LibraryItem> { $0.isFavorite })
    private var favorites: [LibraryItem]

    @State private var mode: FavoritesMode = .normal
    @State private var showGrid = true
    @State private var searchText = ""
    @State private var selectedMainCategory: String = "All"
    @State private var selectedSort: SortOption = .titleAZ
    @State private var selectedItem: LibraryItem?

    let categories = ["All","Book","Manga","Manhwa","Manhua","Comic"]

    var filteredFavorites: [LibraryItem] {
        favorites
            .filter {
                selectedMainCategory == "All" ||
                $0.category == selectedMainCategory
            }
            .filter {
                searchText.isEmpty ||
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }
            .sorted(by: sortComparator)
    }

    var body: some View {

        NavigationStack {

            VStack(spacing: 0) {
                if !favorites.isEmpty {
                    CategoryChipsView(
                        categories: categories,
                        selected: $selectedMainCategory
                    )
                }

                Group {
                    if favorites.isEmpty {
                        ContentUnavailableView(
                            "No Favorites Yet ⭐",
                            systemImage: "star",
                            description: Text("Mark items as favorite to see them here.")
                        )
                    } else if filteredFavorites.isEmpty {
                        ContentUnavailableView(
                            "No Matching Favorites",
                            systemImage: "line.3.horizontal.decrease.circle",
                            description: Text("Try a different category or search text.")
                        )
                    } else {
                        Group {
                            if showGrid {
                                LibraryGridView(
                                    items: filteredFavorites,
                                    selectedItem: $selectedItem,
                                    isEditing: .constant(false)
                                )
                            } else {
                                LibraryListView(
                                    items: filteredFavorites,
                                    selectedItem: $selectedItem
                                )
                            }
                        }
                    }
                }
            }
            .background(Color.libraryBackground)
            .navigationTitle("Favorites ⭐")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        if mode == .searching {
                            HStack {
                                Image(systemName: "magnifyingglass")

                                TextField("Search title or author", text: $searchText)

                                Button("Cancel") {
                                    withAnimation {
                                        searchText = ""
                                        mode = .normal
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(width: 260)
                            .transition(.move(edge: .trailing))

                            Menu {
                                sortMenuContent
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                        } else {
                            Menu {
                                sortMenuContent
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }

                            Button {
                                showGrid.toggle()
                            } label: {
                                Image(systemName:
                                    showGrid
                                    ? "list.bullet"
                                    : "square.grid.2x2")
                            }

                            Button {
                                withAnimation(.easeInOut) {
                                    mode = .searching
                                }
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                    }
                }
            }
            .navigationDestination(item: $selectedItem) {
                ItemDetailView(item: $0)
            }
        }
    }

    @ViewBuilder
    private var sortMenuContent: some View {
        ForEach(SortOption.allCases, id: \.self) { option in
            Button {
                selectedSort = option
            } label: {
                if selectedSort == option {
                    Label(option.rawValue, systemImage: "checkmark")
                } else {
                    Text(option.rawValue)
                }
            }
        }
    }

    private func sortComparator(_ lhs: LibraryItem, _ rhs: LibraryItem) -> Bool {
        switch selectedSort {
        case .titleAZ:
            let compare = lhs.title.localizedCaseInsensitiveCompare(rhs.title)
            if compare == .orderedSame {
                return lhs.author.localizedCaseInsensitiveCompare(rhs.author) == .orderedAscending
            }
            return compare == .orderedAscending
        case .titleZA:
            let compare = lhs.title.localizedCaseInsensitiveCompare(rhs.title)
            if compare == .orderedSame {
                return lhs.author.localizedCaseInsensitiveCompare(rhs.author) == .orderedDescending
            }
            return compare == .orderedDescending
        case .authorAZ:
            let compare = lhs.author.localizedCaseInsensitiveCompare(rhs.author)
            if compare == .orderedSame {
                return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
            }
            return compare == .orderedAscending
        case .authorZA:
            let compare = lhs.author.localizedCaseInsensitiveCompare(rhs.author)
            if compare == .orderedSame {
                return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedDescending
            }
            return compare == .orderedDescending
        case .progressLowHigh:
            let lhsValue = Double(lhs.currentProgress) / Double(max(lhs.totalCount, 1))
            let rhsValue = Double(rhs.currentProgress) / Double(max(rhs.totalCount, 1))
            if lhsValue == rhsValue {
                return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
            }
            return lhsValue < rhsValue
        case .progressHighLow:
            let lhsValue = Double(lhs.currentProgress) / Double(max(lhs.totalCount, 1))
            let rhsValue = Double(rhs.currentProgress) / Double(max(rhs.totalCount, 1))
            if lhsValue == rhsValue {
                return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
            }
            return lhsValue > rhsValue
        }
    }
}
