//
//  MockServices.swift
//  RecipesTests
//
//  Created by Arth Jani on 2/13/25.
//

import Foundation
@testable import Recipes

class MockNetworkService: NetworkServiceProtocol {
    var mockRecipes: [Recipe]?
    var mockError: NetworkError?
    
    //making sure the request is working and then returns local data
    func fetchRecipes(from urlString: String) async throws -> [Recipe] {
        if let error = mockError {
            throw error
        }
        return mockRecipes ?? []
    }
}

// Mock recipe data for testing
extension Recipe {
    static func mockRecipes() -> [Recipe] {
        return [
            Recipe(uuid: "1",
                   name: "Test Recipe 1",
                   cuisine: "Italian",
                   photoUrlLarge: "https://example.com/large1.jpg",
                   photoUrlSmall: "https://example.com/small1.jpg",
                   sourceUrl: "https://example.com/recipe1",
                   youtubeUrl: nil),
            Recipe(uuid: "2",
                   name: "Test Recipe 2",
                   cuisine: "Mexican",
                   photoUrlLarge: "https://example.com/large2.jpg",
                   photoUrlSmall: "https://example.com/small2.jpg",
                   sourceUrl: "https://example.com/recipe2",
                   youtubeUrl: nil)
        ]
    }
}
