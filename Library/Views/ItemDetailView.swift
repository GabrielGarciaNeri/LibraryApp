import SwiftUI
import SwiftData

struct ItemDetailView: View {

    @Environment(\.dismiss) private var dismiss

    var item: LibraryItem

    @State private var title: String
    @State private var author: String
    @State private var descriptionText: String

    @State private var category: String
    @State private var status: String

    @State private var currentProgress: Int
    @State private var totalCount: Int

    @State private var isFavorite: Bool

    let categories = ["Book", "Manga", "Manhwa", "Manhua", "Comic"]
    let statuses = ["Planning", "Reading", "Finished", "Dropped"]

    // MARK: - Init (loads item values into draft fields so i can confimr or cancel)
    init(item: LibraryItem) {
        self.item = item

        _title = State(initialValue: item.title)
        _author = State(initialValue: item.author)
        _descriptionText = State(initialValue: item.shortDescription)

        _category = State(initialValue: item.category)
        _status = State(initialValue: item.status)

        _currentProgress = State(initialValue: item.currentProgress)
        _totalCount = State(initialValue: item.totalCount)

        _isFavorite = State(initialValue: item.isFavorite)
    }

    var body: some View {
        Form {

            //Cover
            Section {
                Image(systemName: "book.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .padding()
            }

            //Basic Info
            Section("Basic Info") {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
            }

            //Description
            Section("Description") {
                TextField("Short Description", text: $descriptionText)
            }

            //Category
            Section("Category") {
                Picker("Type", selection: $category) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat)
                    }
                }
            }

            //Status
            Section("Status") {
                Picker("Reading Status", selection: $status) {
                    ForEach(statuses, id: \.self) { stat in
                        Text(stat)
                    }
                }
            }

            //Progress
            Section("Progress") {

                TextField("Current Progress",
                          value: $currentProgress,
                          format: .number)
                    .keyboardType(.numberPad)

                TextField("Total Pages/Chapters",
                          value: $totalCount,
                          format: .number)
                    .keyboardType(.numberPad)

                Text("Progress: \(currentProgress)/\(totalCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            //Favorite
            Section("Favorite") {
                Toggle("Favorite ⭐", isOn: $isFavorite)
            }
        }
        .navigationTitle("Edit Item")
        .navigationBarTitleDisplayMode(.inline)

        //save + Cancel Buttons
        .toolbar {

            //cancel (discard edits)
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            //save (apply edits)
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let safeTotal = max(totalCount, 0)
                    let safeCurrent = min(max(currentProgress, 0), safeTotal)

                    //apply draft
                    item.title = title
                    item.author = author
                    item.shortDescription = descriptionText

                    item.category = category
                    item.status = status

                    item.totalCount = safeTotal
                    item.currentProgress = safeCurrent

                    item.isFavorite = isFavorite

                    dismiss()
                }
            }
        }
    }
}
