//
//  NetworkServiceTests.swift
//  RecipesTests
//
//  Created by Arth Jani on 2/13/25.
//

import XCTest
@testable import Recipes

class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    
    override func setUp() {
        super.setUp()
        sut = NetworkService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchRecipesInvalidURL() async {
        // Given
        let invalidURL = "not a url"
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes(from: invalidURL)
            XCTFail("Expected error for invalid URL")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
}
