//
//  NetworkManager.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//
import UIKit

enum DataManager {
    // MARK: - Properties
    private static let cache = NSCache<NSString, UIImage>()

    enum NetworkData {
        // MARK: public methods
        static func fetchBooks(
            maxResults: Int? = Constants.API.maxResults,
            startIndex: Int? = nil
        ) async throws -> [Book] {
            guard let url = endpoint(
                maxResults: maxResults,
                startIndex: startIndex
            ) else {
                throw NetworkError.invalidURL
            }
                        
            let (data, response) = try await URLSession.shared.data(from: url)

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidServerResponse
            }

            let bookResponse = try JSONDecoder().decode(
                BookResponse.self,
                from: data
            )
            
            let books = bookResponse.items
            
            print("[DataManager] \(books.count) books retrieved from network.")
            
            return books
        }
        
        static func getImage(from url: URL?) async throws -> UIImage {
            guard let url else {
                throw NetworkError.invalidURL
            }
            
            // Used as the key for cache storage
            let cacheKey = url.absoluteString as NSString
            
            // Return image from cache if available
            if let cachedImage = cache.object(forKey: cacheKey) {
                print("[DataManager] image retrieved from cache: \(cacheKey).")
                return cachedImage
            }
            
            // Return image from network if available and save it to cache
            let image = try await fetchImage(from: url)
            print("[DataManager] image retrieved form network: \(url).")
            cache.setObject(image, forKey: cacheKey)
            return image

        }
        
        // MARK: private methods
        static private func fetchImage(from url: URL?) async throws -> UIImage {
            guard let url else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidServerResponse
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.invalidImageData
            }
    
            return image
        }
        
        // MARK: - Enpoint creation
        static func endpoint(
            maxResults: Int?,
            startIndex: Int?
        ) -> URL? {
            var components = URLComponents()
            components.path = Constants.API.URL.path
            components.scheme = Constants.API.URL.scheme
            components.host = Constants.API.URL.host
            
            var queryItems = [URLQueryItem(
                    name: Constants.API.URL.QueryItems.SearchTerm.name,
                    value: Constants.API.URL.QueryItems.SearchTerm.iOSSearchTerm
            )]
            
            if let maxResults {
                queryItems.append(URLQueryItem(
                    name: Constants.API.URL.QueryItems.MaxResults.name,
                    value: String(maxResults)
                ))
            }
            
            if let startIndex {
                queryItems.append(URLQueryItem(
                    name: Constants.API.URL.QueryItems.StartIndex.name,
                    value: String(startIndex))
                )
            }
            
            components.queryItems = queryItems
            
            return components.url
            
        }
    }
    
    enum LocalData {
        // MARK: - Mock data
        static func getMockedBooks() async throws -> [Book] {
            guard let url = Bundle.main.url(forResource: "books", withExtension: "json"
            ) else {
                throw NetworkError.invalidURL
            }
            
            let data = try Data(contentsOf: url)
            let bookResponse = try JSONDecoder().decode(
                BookResponse.self,
                from: data
            )
            let books = bookResponse.items
            print("[DataManager] \(books.count) books retrieved from mocked API.")
            return books
        }
        
        // MARK: - User defaults
        static var favoriteIds: Set<String> {
            get {
                guard let value = UserDefaults.standard.array(forKey: Constants.UserDefaultsKeys.favoriteIds) as? [String] else {
                    return Set<String>()
                }
                
                let favoriteIdsSet = Set(value)
                return favoriteIdsSet
            }
            set {
                let favoriteIdsArray = Array(newValue)
                UserDefaults.standard.set(favoriteIdsArray, forKey: Constants.UserDefaultsKeys.favoriteIds)
            }
        }
        
        static var shouldDisplayFavorites: Bool {
            get {
                guard let value = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.shouldDisplayFavorites) as? Bool else {
                    return false
                }
                
                return value
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKeys.shouldDisplayFavorites)
            }
        }

    }
}
