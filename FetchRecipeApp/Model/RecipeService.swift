//
//  RecipeService.swift
//  FetchRecipeApp
//
//  Created by Robert Fusting on 12/11/24.
//

import Foundation

final class RecipeService {
    
    
    enum ErrorHandler: Error {
        case invalidServerResponse
        case invalidURL
    }
    
    
    func fetchRecipe() async throws -> [RecipeModel] {
        
        print("invoked")
        
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw ErrorHandler.invalidURL
        }
                
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        let decoder = JSONDecoder()
        
        let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
        
        return recipeResponse.recipes

    }
    
}
