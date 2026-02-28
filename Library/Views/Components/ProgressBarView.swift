
import SwiftUI

struct ProgressBarView: View {

    var current: Int
    var total: Int

    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            GeometryReader { geo in
                ZStack(alignment: .leading) {

                    Capsule()
                        .fill(Color.gray.opacity(0.2))

                    Capsule()
                        .fill(Color.accentColor)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 6)

            Text("\(current)/\(total)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}
