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
        private var allBooks: [Book] = []
        
        // MARK: - Public properties
        var shouldDisplayFavorites: Bool {
            get {
                DataManager.LocalData.shouldDisplayFavorites
            }
            set {
                DataManager.LocalData.shouldDisplayFavorites = newValue
            }
        }
        var onDataUpdated: (() -> Void)?
        var onBookSelected: ((Book) -> Void)?
        var numberOfBooks: Int {
            booksToDisplay.count
        }
        var favoriteBooks: [Book] {
            allBooks.filter { DataManager.LocalData.favoriteIds.contains($0.id) }
        }
        var booksToDisplay: [Book] {
            shouldDisplayFavorites ? favoriteBooks : allBooks
        }
        let emptyListMessage = String(localized: "main_view_empty_list_message")
        
        // MARK: - Public methods
        func bookCellViewModel(at index: Int) -> BookCellView.ViewModel {
            BookCellView.ViewModel(book: booksToDisplay[index])
        }
        
        func book(at index: Int) -> Book? {
            guard index >= 0 && index < booksToDisplay.count else {
                print("Index \(index) out of bounds for booksToDisplay array.")
                return nil
            }
            return booksToDisplay[index]
        }
        
        func toggleFavorites() {
            shouldDisplayFavorites.toggle()
            // Notify the view that data is updated
            onDataUpdated?()
        }
        
        func getBooks() async throws {
            // Uncomment below to use mocked data
            //allBooks = try await DataManager.LocalData.getMockedBooks()
            allBooks = try await DataManager.NetworkData.fetchBooks()
            // Notify the view that data is updated
            onDataUpdated?()
        }
    }
}
