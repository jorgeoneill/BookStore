//
//  Untitled.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//

import UIKit

extension BookCellView {
    final class ViewModel {
        // MARK: - Private properties
        private let book: Book
        private var thumbnailImage: UIImage?
        

        /*
        var title: String {
            return book.volumeInfo.title
        }
         
         */
        
        private var thumbnailURL: URL? {
            return URL(string: book.volumeInfo.imageLinks?.thumbnail ?? "")
        }
        
        // MARK: - Lifecycle
        init(book: Book) {
            self.book = book
        }
        
        
        // MARK: - Public methods
        func fetchThumbnailImage() async -> UIImage? {
            guard let url = thumbnailURL else {
                return nil
            }
            
            do {
                thumbnailImage = try await DataManager.NetworkData.getImage(from: url)
                return thumbnailImage
            } catch {
                print("[BookCellView.ViewModel] Failed to fetch image: \(error)")
                return nil
            }
        }
    }
}


