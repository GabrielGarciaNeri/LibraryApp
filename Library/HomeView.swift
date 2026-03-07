import SwiftUI
import SwiftData

struct HomeView: View {
    
    enum SortOption: String, CaseIterable {
        case titleAZ = "Title A-Z"
        case titleZA = "Title Z-A"
        case authorAZ = "Author A-Z"
        case authorZA = "Author Z-A"
        case progressLowHigh = "Progress Low-High"
        case progressHighLow = "Progress High-Low"
    }

    @Query private var items: [LibraryItem]
    
    enum LibraryMode {
        case normal
        case searching
        case deleting
    }
    
    @State private var mode: LibraryMode = .normal
    @State private var showGrid = true
    @State private var showAddScreen = false
    @State private var searchText = ""
    @State private var selectedMainCategory: String = "All"
    @State private var selectedSort: SortOption = .titleAZ
    @State private var selectedItem: LibraryItem?
    @State private var isGridEditing: Bool = false
    
    let categories = ["All","Book","Manga","Manhwa","Manhua","Comic"]
    
    // MARK: FILTER FOR MAIN CATEGORIES
    var filteredItems: [LibraryItem] {
        items
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
    
    // MARK: BODY
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                
                CategoryChipsView(
                    categories: categories,
                    selected: $selectedMainCategory
                )
                
                Group {
                    if showGrid {
                        LibraryGridView(
                            items: filteredItems,
                            selectedItem: $selectedItem,
                            isEditing: $isGridEditing
                        )
                    } else {
                        LibraryListView(
                            items: filteredItems,
                            selectedItem: $selectedItem
                        )
                    }
                }
                
                //                if showGrid {
                //                    gridView
                //                } else {
                //                    listView
                //                }
            }
            .background(Color.libraryBackground)
            .navigationTitle("My Library")
            
            // MARK: TOOLBAR
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

                            if showGrid && isGridEditing {
                                Button("Done") {
                                    isGridEditing = false
                                }
                            }

                            Menu {
                                sortMenuContent
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                            
                            Button {
                                showGrid.toggle()
                                isGridEditing = false
                            } label: {
                                Image(systemName:
                                        showGrid
                                      ? "list.bullet"
                                      : "square.grid.2x2")
                            }
                            
                            Button {
                                showAddScreen = true
                            } label: {
                                Image(systemName: "plus")
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
            .sheet(isPresented: $showAddScreen) {
                AddItemView()
            }
            .navigationDestination(item: $selectedItem) {
                ItemDetailView(item: $0)
            }
            .onDisappear {
                isGridEditing = false
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
//MARK: - Filtering and Sorting
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
