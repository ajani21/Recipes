//
//  NetworkService.swift
//  Recipies
//
//  Created by Arth Jani on 2/12/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown
    
    // User friendly message
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Error processing data"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
    
    // Used for test cases to comapre errors
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.decodingError, .decodingError):
            return true
        case (.unknown, .unknown):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}

//makes network call + parse it
actor NetworkService: NetworkServiceProtocol {
    func fetchRecipes(from urlString: String) async throws -> [Recipe] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            do {
                let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                return recipeResponse.recipes
            } catch {
                throw NetworkError.decodingError
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.invalidURL
        }
    }
}
