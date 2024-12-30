
import Foundation
import SwiftUI

final class RecipeService {
    
    enum ErrorHandler: Error {
        case invalidServerResponse
        case invalidURL
        case imageDecodeFailure
    }
    
    private var url : String
    
    init(url: String) {
        self.url = url
    }
    
    //function we use to download recipe JSON from provided url
    func fetchRecipe() async throws -> [RecipeModel] {
        
        guard let url = URL(string: url) else {
            throw ErrorHandler.invalidURL
        }
        
        //we attempt to fetch the data from the internet
        let (data,response) = try await URLSession.shared.data(from: url)
        
        //Check if the response we got was successful
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        // we got a 200 response, which means we successfully got data so we can try to decode it
        let decoder = JSONDecoder()
        
        // if decoding fails we will throw an error otherwise we return the recipes
        let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
        
        return recipeResponse.recipes

    }
    
    // we use this function to fetch images found in the recipes
    func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ErrorHandler.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        // try to decode data into UIImage, if it fails we throw an error
        guard let image = UIImage(data: data) else {
            throw ErrorHandler.imageDecodeFailure
        }
        
        return image
    }
}
