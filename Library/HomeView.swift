

import SwiftUI
import SwiftData

struct HomeView: View {

    @Environment(\.modelContext) private var context //saves content
    @Query private var items: [LibraryItem] //loads my library itesm
    @State private var showGrid = true //toggle between grid and list
    @State private var showAddScreen = false

    var body: some View {
        NavigationStack {
            Group {
                if showGrid {
                    gridView
                } else {
                    listView
                }
            }
            .navigationTitle("My Library")
            .toolbar {
                Button { //button list or grid
                    showGrid.toggle()
                } label: {
                    Image(systemName: showGrid
                          ? "list.bullet"
                          : "square.grid.2x2")
                }

                Button { //add new item
                    showAddScreen = true
                } label: {
                    Image(systemName: "plus")
                }
                
                //only show edit button when in List mode
                if !showGrid {
                    EditButton()
                }

            }
            .sheet(isPresented: $showAddScreen) {
                AddItemView()
            }
        }
    }

    // MARK: - List View
    private var listView: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)

                        Text(item.author)
                            .foregroundColor(.gray)

                        Text("Progress: \(item.currentProgress)/\(item.totalCount)")
                            .font(.caption)
                    }
                }
                .padding(.vertical, 4)
            }
            .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(items[index])
                }
            }
        }
    }

    // MARK: - Grid View
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {

                ForEach(items) { item in
                    NavigationLink {
                        ItemDetailView(item: item)
                    } label: {
                        VStack(spacing: 8) {

                            Image(systemName: "book.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)

                            Text(item.title)
                                .font(.headline)
                                .lineLimit(2)

                            Text(item.author)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        .frame(width: 140, height: 180)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
