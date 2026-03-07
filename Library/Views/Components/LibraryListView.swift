
import SwiftUI
import SwiftData

struct LibraryListView: View {

    let items: [LibraryItem]

    @Binding var selectedItem: LibraryItem?

    @Environment(\.modelContext) private var context

    var body: some View {

        List {

            ForEach(items) { item in

                VStack(alignment: .leading, spacing: 6) {

                    HStack {

                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)

                            Text(item.author)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // favorite button
                        Button {
                            item.isFavorite.toggle()
                        } label: {
                            Image(systemName:
                                item.isFavorite ? "star.fill" : "star"
                            )
                            .font(.title3)
                            .foregroundStyle(Color(hex: "#F2B705"))
                        }
                        .buttonStyle(.plain) //needed if not star bugs
                    }

                    ProgressBarView(
                        current: item.currentProgress,
                        total: item.totalCount
                    )

                    ProgressInputView(item: item)
                }
                .contentShape(Rectangle())
                .listRowBackground(Color.libraryCard)
                .listRowSeparatorTint(Color.libraryStroke)
                .onTapGesture {
                    selectedItem = item
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    context.delete(items[index])
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.libraryBackground)
    }
}
