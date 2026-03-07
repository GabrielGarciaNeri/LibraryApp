
import SwiftUI

struct ProgressBarView: View {

    var current: Int
    var total: Int

    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }

    var body: some View {

        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.libraryChipIdle)

                Capsule()
                    .fill(Color.libraryAccent)
                    .frame(width: geo.size.width * progress)
            }
        }
        .frame(height: 6)
    }
}
