
import SwiftUI
import SwiftData

struct LibraryGridView: View {

    let items: [LibraryItem]

    @Binding var selectedItem: LibraryItem?
    @Binding var pendingDeleteID: PersistentIdentifier?
    @Binding var isEditing: Bool

    @Environment(\.modelContext) private var context

    var body: some View {

        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))]) {

                ForEach(items) { item in

                    ZStack(alignment: .topTrailing) {

                        //card
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

                            ProgressBarView(
                                current: item.currentProgress,
                                total: item.totalCount
                            )
                            .frame(width: 100)
                            .onTapGesture { // progress only goes up for now
                                item.currentProgress += 1
                            }
                        }
                        .frame(width: 140, height: 180)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                        // favorite button as a star
                        Button {
                            item.isFavorite.toggle()
                        } label: {
                            Image(systemName:
                                item.isFavorite ? "star.fill" : "star"
                            )
                            .foregroundStyle(.yellow)
                            .padding(8)
                        }

                        // delete by holding down
                        if isEditing {
                            Button {
                                context.delete(item)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.red)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            .offset(x: -125, y: -7) //location of delete button
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItem = item
                    }
                    .onLongPressGesture {
                        isEditing = true
                    }
                }
            }
            .padding()
        }
    }
}

