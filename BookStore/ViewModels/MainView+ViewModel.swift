//
//  MainView+ViewModel.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//

import UIKit

extension MainView {
    final class ViewModel {
       
        // MARK: - Private properties
        private var books: [Book] = []
        
        // MARK: - Public properties
        var onDataUpdated: (() -> Void)?
        
        var numberOfBooks: Int {
            return books.count
        }
        
        // MARK: - Public methods
        func bookCellViewModel(at index: Int) -> BookCellView.ViewModel {
            return BookCellView.ViewModel(book: books[index])
        }
        
        func getBooks() async {
            do {
                books = try await DataManager.NetworkData.fetchBooks()
                //books = try await DataManager.LocalData.getMockedBooks()
                // Notify the view that data is updated
                onDataUpdated?()
            } catch {
                print("[MainView.ViewModel] Failed to fetch books: \(error)")
            }
        }
        
    }
}
