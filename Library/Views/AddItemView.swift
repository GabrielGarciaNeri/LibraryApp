

import SwiftUI
import SwiftData

struct AddItemView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var descriptionText = ""
    @State private var totalCount = 1
    @State private var category = "Manhwa"

    let categories = ["Book", "Manga", "Manhwa", "Manhua", "Comic"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                }
                
                Section("Description") {
                    TextField("Short description", text: $descriptionText)
                }

                Section("Progress") {
                    TextField("Total Pages/Chapters", value: $totalCount, format: .number)
                        .keyboardType(.numberPad)
                }

                Section("Category") {
                    Picker("Type", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                }
            }
            .navigationTitle("Add New Item")

            .toolbar {
                ToolbarItem(placement: .cancellationAction) { // Cancel button
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) { // Save button
                    Button("Save") {
                        saveItem()
                    }
                    .disabled(title.isEmpty || author.isEmpty)
                }
            }
        }
    }

    // MARK: - Save Function
    private func saveItem() {

        let newItem = LibraryItem(
            title: title,
            author: author,
            shortDescription: descriptionText,
            category: category,
            totalCount: totalCount
            
        )

        context.insert(newItem)
        dismiss()
    }
}

