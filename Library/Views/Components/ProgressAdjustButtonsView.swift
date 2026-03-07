import SwiftUI

struct ProgressInputView: View {

    enum Field {
        case current
        case total
    }

    let item: LibraryItem

    @State private var editingField: Field?
    @State private var draftValue = ""

    var body: some View {
        HStack(spacing: 5) {
            valueButton("\(item.currentProgress)") {
                draftValue = "\(item.currentProgress)"
                editingField = .current
            }

            Text("/")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)

            valueButton("\(item.totalCount)") {
                draftValue = "\(item.totalCount)"
                editingField = .total
            }
        }
        .alert(alertTitle, isPresented: isEditingBinding) {
            TextField("Enter number", text: $draftValue)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {
                editingField = nil
            }
            Button("Save") {
                saveDraft()
            }
        } message: {
            Text("Tap Save to update this value.")
        }
    }

    @ViewBuilder
    private func valueButton(_ text: String, action: @escaping () -> Void) -> some View {
        Button(text, action: action)
        .font(.caption2.weight(.semibold))
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Color.libraryAccentSoft)
        .foregroundStyle(Color.libraryAccent)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .buttonStyle(.plain)
    }

    private var alertTitle: String {
        switch editingField {
        case .current: return "Set Current Progress"
        case .total: return "Set Total Count"
        case .none: return "Update Value"
        }
    }

    private var isEditingBinding: Binding<Bool> {
        Binding(
            get: { editingField != nil },
            set: { showing in
                if !showing {
                    editingField = nil
                }
            }
        )
    }

    private func saveDraft() {
        guard let value = Int(draftValue), let editingField else {
            return
        }

        if editingField == .current {
            item.setCurrentProgress(value)
        } else {
            item.setTotalCount(value)
        }

        self.editingField = nil
    }
}
