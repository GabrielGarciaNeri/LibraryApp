
import SwiftUI
import SwiftData

struct LibraryGridView: View {

    let items: [LibraryItem]

    @Binding var selectedItem: LibraryItem?
    @Binding var isEditing: Bool

    @Environment(\.modelContext) private var context
    @State private var itemPendingDelete: LibraryItem?

    var body: some View {

        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))]) {

                ForEach(items) { item in

                    ZStack {

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

                            ProgressInputView(item: item)
                        }
                        .frame(width: 140, height: 195)
                        .background(Color.libraryCard)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.libraryStroke, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

                        // top-left delete stays inside card
                        if isEditing {
                            Button {
                                itemPendingDelete = item
                            } label: {
                                Text("Delete")
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background(Color.libraryDanger)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(8)
                        }

                        // top-right favorite stays inside card
                        Button {
                            if isEditing {
                                isEditing = false
                            } else {
                                item.isFavorite.toggle()
                            }
                        } label: {
                            Image(systemName:
                                item.isFavorite ? "star.fill" : "star"
                            )
                            .foregroundStyle(Color(hex: "#F2B705"))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(8)
                    }
                    .frame(width: 140, height: 195)
                    .clipped()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isEditing {
                            isEditing = false
                        } else {
                            selectedItem = item
                        }
                    }
                    .onLongPressGesture {
                        isEditing = true
                    }
                }
            }
            .padding()
        }
        .onTapGesture {
            if isEditing {
                isEditing = false
            }
        }
        .alert("Delete this item?", isPresented: deleteAlertBinding) {
            Button("Cancel", role: .cancel) {
                itemPendingDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let itemPendingDelete {
                    context.delete(itemPendingDelete)
                }
                itemPendingDelete = nil
            }
        } message: {
            if let itemPendingDelete {
                Text(itemPendingDelete.title)
            } else {
                Text("This action cannot be undone.")
            }
        }
    }

    private var deleteAlertBinding: Binding<Bool> {
        Binding(
            get: { itemPendingDelete != nil },
            set: { showing in
                if !showing {
                    itemPendingDelete = nil
                }
            }
        )
    }
}
