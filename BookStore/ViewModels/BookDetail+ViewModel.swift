//
//  BookDetail+ViewModel.swift
//  BookStore
//
//  Created by Jorge O'Neill on 08/10/2024.
//

import UIKit

extension BookDetailView {
    final class ViewModel {
        // MARK: - Public properties
        let id: String
        let title: String
        let author: String
        let formattedDescription: NSAttributedString
        let buyLink: URL?
        var isFavorite: Bool {
            get {
                DataManager.LocalData.favoriteIds.contains(id)
            }
            set {
                if newValue {
                    DataManager.LocalData.favoriteIds.insert(id)
                } else  {
                    DataManager.LocalData.favoriteIds.remove(id)
                }
            }
        }
        
        // MARK: - Lifecycle
        init(book: Book) {
            self.id = book.id
            self.title = book.volumeInfo.title
            self.author = book.volumeInfo.authors?.joined(separator: String(localized: "book_detail_authors_separator")) ?? String(localized: "book_detail_default_author")
            
            // Setup the attributted string for formattedDescription
            let descriptionString = book.volumeInfo.description ?? String(localized: "book_detail_default_description")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6  // Increase line spacing
            paragraphStyle.alignment = .justified  // Justify the text for a cleaner look
            let attributedText = NSAttributedString(
                string: descriptionString,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16),
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.label // Adapts to light/dark mode
                ]
            )
            formattedDescription = attributedText
            
            // flatMap safely handles both the case where buyLink is nil and where the URL initialization fails, ensuring that the result is either a valid URL? or nil, without nesting optionals.
            self.buyLink = book.saleInfo.buyLink.flatMap { URL(string: $0) }
        }
    }
}
