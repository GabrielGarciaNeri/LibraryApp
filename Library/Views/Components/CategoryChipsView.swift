
import SwiftUI

struct CategoryChipsView: View {

    let categories: [String]
    @Binding var selected: String

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {

                ForEach(categories, id: \.self) { category in

                    Button {
                        selected = category
                    } label: {
                        Text(category)
                            .font(.subheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                selected == category
                                ? Color.accentColor
                                : Color(.systemGray5)
                            )
                            .foregroundColor(
                                selected == category
                                ? .white
                                : .primary
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
