//
//  RecipeViewModel.swift
//  Recipies
//
//  Created by Arth Jani on 2/12/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private let recipeURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var error: NetworkError?
    @Published private(set) var isLoading = false
    
    // To handle with Dependency Injection
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // Returns dictionary of cusine as key and a sorted array of [Recipies] for each
    var groupedRecipes: [String: [Recipe]] {
        Dictionary(grouping: recipes) { $0.cuisine }
            .mapValues { $0.sorted { $0.name < $1.name } }
    }
    
    // Unique cuisines
    var cuisineTypes: [String] {
        Array(groupedRecipes.keys).sorted()
    }
    
    // Tries to fetch recipes + catches error, if needed
    func loadRecipes() async {
        isLoading = true
        error = nil
        
        do {
            recipes = try await networkService.fetchRecipes(from: recipeURL)
        } catch let networkError as NetworkError {
            error = networkError
            recipes = []
        } catch {
            self.error = .unknown
            recipes = []
        }
        
        isLoading = false
    }
}
