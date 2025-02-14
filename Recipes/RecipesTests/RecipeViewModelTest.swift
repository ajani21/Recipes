//
//  RecipeViewModelTest.swift
//  RecipesTests
//
//  Created by Arth Jani on 2/13/25.
//

import XCTest
@testable import Recipes

@MainActor
class RecipeViewModelTests: XCTestCase {
    var sut: RecipeViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = RecipeViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testLoadRecipesSuccess() async {
        // Given
        let expectedRecipes = Recipe.mockRecipes()
        mockNetworkService.mockRecipes = expectedRecipes
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(sut.recipes.count, expectedRecipes.count)
        XCTAssertEqual(sut.recipes, expectedRecipes)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadRecipesFailure() async {
        // Given
        mockNetworkService.mockError = NetworkError.serverError(500)
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error, .serverError(500))
        XCTAssertFalse(sut.isLoading)
    }
    
    func testGroupedRecipes() async {
        // Given
        let mockRecipes = Recipe.mockRecipes()
        mockNetworkService.mockRecipes = mockRecipes
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(sut.cuisineTypes.count, 2) // Italian and Mexican
        XCTAssertEqual(sut.groupedRecipes["Italian"]?.count, 1)
        XCTAssertEqual(sut.groupedRecipes["Mexican"]?.count, 1)
    }
    
    func testCuisineTypesSorting() async {
        // Given
        let mockRecipes = Recipe.mockRecipes()
        mockNetworkService.mockRecipes = mockRecipes
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(sut.cuisineTypes, ["Italian", "Mexican"]) // Should be alphabetically sorted
    }
}
