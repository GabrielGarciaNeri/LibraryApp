

import SwiftUI
import SwiftData

struct AddItemView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var descriptionText = ""
    @State private var isFavorite = false
    @State private var currentProgress = 1
    @State private var totalCount = 1
    @State private var category = "Manhwa"
    @State private var subcategory: String = "General"

    let categories = ["Book", "Manga", "Manhwa", "Manhua", "Comic"]
    
    var subcategories: [String] {
        Subcategories.map[category] ?? ["General"]
    }

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
                    TextField ("Current Page/Chapter", value: $currentProgress, format: .number)
                        .keyboardType(.numberPad)
                    TextField("Total Pages/Chapters", value: $totalCount, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section("Favorite") {
                    Toggle("Mark as Favorite ⭐", isOn: $isFavorite)
                }

                Section("Category") {
                    Picker("Type", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    .onChange(of:category) { _ in
                        subcategory = subcategories.first ?? "General"
                    }
                }
                
                Section("Subcategory") {
                    Picker("Subtype", selection: $subcategory) {
                        ForEach(subcategories, id: \.self) { sub in
                            Text(sub)
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
            subcategory: subcategory,
            totalCount: totalCount,
            isFavorite: isFavorite
        )

        context.insert(newItem)
        dismiss()
    }
}

