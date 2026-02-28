
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
                            .foregroundStyle(.yellow)
                        }
                        .buttonStyle(.plain) //needed if not star bugs
                    }

                    ProgressBarView(
                        current: item.currentProgress,
                        total: item.totalCount
                    )
                    .onTapGesture { //only goes up at the moment
                        item.currentProgress += 1
                    }
                }
                .contentShape(Rectangle())
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
    }
}
