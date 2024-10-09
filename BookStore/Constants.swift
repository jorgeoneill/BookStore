//
//  Constants.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//
import UIKit

enum Constants {
    enum API {
        static let maxResults = 40

        enum URL {
            static let scheme = "https"
            static let host = "www.googleapis.com"
            static let path = "/books/v1/volumes"
            
            enum QueryItems {
                enum SearchTerm {
                    static let name = "q"
                    static let iOSSearchTerm = "ios"
                }
                
                enum StartIndex {
                    static let name = "startIndex"
                }
                
                enum MaxResults {
                    static let name = "maxResults"
                }
            }
        }
    }
    
    enum UI {
        static let favoriteOnSymbolName = "heart.fill"
        static let favoriteOffSymbolName = "heart"
        static let bookCellViewIdentifier = "BookCell"
        static let genericPadding: CGFloat = 16.0
    }
    
    enum UserDefaultsKeys {
        static let favoriteIds = "favoriteIds"
        static let shouldDisplayFavorites = "shouldDisplayFavorites"

    }
}
