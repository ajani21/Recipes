//
//  NetworkServiceProtocol.swift
//  Recipes
//
//  Created by Arth Jani on 2/13/25.
//

import Foundation

// Set network function signature
protocol NetworkServiceProtocol {
    func fetchRecipes(from urlString: String) async throws -> [Recipe]
}
