//
//  RecipeViewModel.swift
//  FetchRecipeApp
//
//  Created by Robert Fusting on 12/10/24.
//

import Foundation

final class RecipeViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var recipeService: RecipeService = RecipeService()
    
    @MainActor
    func populateRecipes() {
            Task {
                let result = try await recipeService.fetchRecipe()
                recipes = result
            }
    }
}
