//
//  BookDetailViewTests.swift
//  BookStoreTests
//
//  Created by Jorge O'Neill on 09/10/2024.
//

import XCTest
@testable import BookStore

final class BookDetailViewTests: XCTestCase {
    
    // System under test property
    var sut: BookDetailView.ViewModel?

    override func setUpWithError() throws {
        // Expectation needs to be set and awaited for fullfilment, because of the asynchronous nature of the data fetching
        let expectation = expectation(description: "Async setup")
        
        Task {
            let books = try await DataManager.LocalData.getMockedBooks()
            let testBook = books[2] // Using 3rd book, which has a buy link.
            sut = BookDetailView.ViewModel(book: testBook)
            expectation.fulfill() // Notify that async setup is done
        }
        
        // Wait for the async operation to complete before continuing with the test
        waitForExpectations(timeout: 5.0)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_idPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.id, "-J1WEAAAQBAJ")
    }
    
    func test_titlePropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.title, "iOS 15 Programming for Beginners")
    }
    
    func test_authoredByPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.authoredBy, "By: Ahmad Sahar, Craig Clayton")
    }
    
    func test_formattedDescriptionPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.formattedDescription.string, "Key Features Explore the latest features of Xcode 13 and the Swift 5.5 programming language in this updated sixth edition Start your iOS programming career and have fun building your own iOS apps Discover the new features of iOS 15 such as Mac Catalyst, SwiftUI, Swift Concurrency, and SharePlay Book DescriptionWith almost 2 million apps on the App Store, iOS mobile apps continue to be incredibly popular. Anyone can reach millions of customers around the world by publishing their apps on the App Store. iOS 15 Programming for Beginners is a comprehensive introduction for those who are new to iOS. It covers the entire process of learning the Swift language, writing your own app, and publishing it on the App Store. Complete with hands-on tutorials, projects, and self-assessment questions, this easy-to-follow guide will help you get well-versed with the Swift language to build your apps and introduce exciting new technologies that you can incorporate into your apps. You\'ll learn how to publish iOS apps and work with Mac Catalyst, SharePlay, SwiftUI, Swift concurrency, and much more. By the end of this iOS development book, you\'ll have the knowledge and skills to write and publish interesting apps, and more importantly, to use the online resources available to enhance your app development journey.What you will learn Get to grips with the fundamentals of Xcode 13 and Swift 5.5, the building blocks of iOS development Understand how to prototype an app using storyboards Discover the Model-View-Controller design pattern and how to implement the desired functionality within an app Implement the latest iOS features such as Swift Concurrency and SharePlay Convert an existing iPad app into a Mac app with Mac Catalyst Design, deploy, and test your iOS applications with design patterns and best practices Who this book is for This book is for anyone who has programming experience but is new to Swift and iOS app development. Basics knowledge of programming, including loops, boolean, and so on, is necessary.")
    }
    
    func test_buyLinkPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.buyLink, URL(string: "https://play.google.com/store/books/details?id=-J1WEAAAQBAJ&rdid=book--J1WEAAAQBAJ&rdot=1&source=gbs_api"))
    }
    
    func test_buyButtonTitlePropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.buyButtonTitle, "Buy Now")
    }

    func test_networkDataFetchingPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            Task {
                try await DataManager.NetworkData.fetchBooks()
            }
        }
    }
    
    func test_mockedDataFetchingPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            Task {
                try await DataManager.LocalData.getMockedBooks()
            }
        }
    }

}
