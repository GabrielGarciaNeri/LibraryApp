import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var context
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
    @State private var pendingDeleteID: PersistentIdentifier?
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
                            pendingDeleteID: $pendingDeleteID,
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
                            
                        } else {
                            
                            Button {
                                showGrid.toggle()
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
        }
    }
    
    
    
    //    // MARK: List View
    //    private var listView: some View {
    //
    //        List {
    //            ForEach(filteredItems) { item in
    //
    //                VStack(alignment: .leading, spacing: 6) {
    //
    //                    HStack {
    //                        Text(item.title)
    //                            .font(.headline)
    //
    //                        Spacer()
    //
    //                        Button {
    //                            item.isFavorite.toggle()
    //                        } label: {
    //                            Image(systemName:
    //                                item.isFavorite ? "star.fill":"star")
    //                                .font(.title3)
    //                                .foregroundStyle(.yellow)
    //                        }
    //                        .buttonStyle(.plain)
    //                    }
    //
    //                    Text(item.author)
    //                        .foregroundColor(.gray)
    //
    //                    ProgressBarView(
    //                        current: item.currentProgress,
    //                        total: item.totalCount
    //                    )
    //                    .onTapGesture {
    //                        item.currentProgress += 1
    //                    }
    //                }
    //                .contentShape(Rectangle())
    //                .onTapGesture {
    //                    selectedItem = item
    //                }
    //            }
    //            .onDelete { indexSet in
    //                for i in indexSet {
    //                    context.delete(filteredItems[i])
    //                }
    //            }
    //        }
    //    }
    //    // MARK: Grid View
    //    private var gridView: some View {
    //
    //        ScrollView {
    //
    //            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
    //
    //                ForEach(filteredItems) { item in
    //
    //                    ZStack(alignment: .topLeading) {
    //
    //                        VStack(spacing: 8) {
    //
    //                            Image(systemName:"book.fill")
    //                                .resizable()
    //                                .scaledToFit()
    //                                .frame(height:70)
    //
    //                            Text(item.title)
    //                                .font(.headline)
    //                                .lineLimit(2)
    //
    //                            Text(item.author)
    //                                .font(.caption)
    //                                .foregroundColor(.gray)
    //
    //                            ProgressBarView(
    //                                current: item.currentProgress,
    //                                total: item.totalCount
    //                            )
    //                            .frame(width: 100) // narrower progress bar
    //                            .onTapGesture { //progress of book only add at the moment
    //                                item.currentProgress += 1
    //                            }
    //                        }
    //                        .frame(width:140,height:180)
    //                        .background(Color(.systemGray6))
    //                        .cornerRadius(12)
    //
    //                        // favorite top
    //                        VStack {
    //                            HStack {
    //
    //                                Button {
    //                                    item.isFavorite.toggle()
    //                                } label: {
    //                                    Image(systemName:
    //                                        item.isFavorite
    //                                        ? "star.fill":"star")
    //                                        .font(.title3)
    //                                        .foregroundStyle(.yellow)
    //                                }
    //                            }
    //                        }
    //                        .padding(8)
    //
    //                        // DELETE MODE
    //                        if mode == .deleting {
    //
    //                            Button {
    //
    //                                if pendingDeleteID ==
    //                                    item.persistentModelID {
    //
    //                                    context.delete(item)
    //                                    pendingDeleteID = nil
    //
    //                                } else {
    //                                    pendingDeleteID =
    //                                    item.persistentModelID
    //                                }
    //
    //                            } label: {
    //
    //                                if pendingDeleteID ==
    //                                    item.persistentModelID {
    //
    //                                    Text("Delete")
    //                                        .font(.caption2)
    //                                        .padding(6)
    //                                        .background(.red)
    //                                        .foregroundColor(.white)
    //                                        .cornerRadius(6)
    //
    //                                } else {
    //
    //                                    Image(systemName:"minus.circle.fill")
    //                                        .foregroundColor(.red)
    //                                        .background(.white)
    //                                        .clipShape(Circle())
    //                                }
    //                            }
    //                            .padding(6)
    //                        }
    //                    }
    //                    .contentShape(Rectangle())
    //                    .onTapGesture {
    //                        selectedItem = item
    //                    }
    //                    .onLongPressGesture {
    //                        mode = .deleting
    //                    }
    //                }
    //            }
    //            .padding()
    //        }
    //    }
    //
    //}
    
}

