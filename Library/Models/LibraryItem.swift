import Foundation
import SwiftData

@Model
class LibraryItem {

    var title: String
    var author: String
    var shortDescription: String

    var category: String
    var status: String

    var totalCount: Int
    var currentProgress: Int

    var isFavorite: Bool
    var lastUpdated: Date

    init(
        title: String,
        author: String,
        shortDescription: String = "",
        category: String,
        status: String = "Planning",
        totalCount: Int,
        currentProgress: Int = 0,
        isFavorite: Bool = false,
        lastUpdated: Date = .now
    ) {
        self.title = title
        self.author = author
        self.shortDescription = shortDescription

        self.category = category
        self.status = status

        self.totalCount = totalCount
        self.currentProgress = currentProgress

        self.isFavorite = isFavorite
        self.lastUpdated = lastUpdated
    }
}



