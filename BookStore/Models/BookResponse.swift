//
//  Book.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//

import Foundation

struct BookResponse: Decodable {
    let items: [Book]
}

struct Book: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    let infoLink: String?
    
    struct ImageLinks: Decodable {
        let thumbnail: String
    }
}
