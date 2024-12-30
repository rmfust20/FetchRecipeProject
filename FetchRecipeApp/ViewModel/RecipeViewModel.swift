import Foundation
import SwiftUI

final class RecipeViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var caughtError = false

    private let recipeService: RecipeService
    private let cache = RecipeCache.instance

    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }

    @MainActor
    //We use this function to fill the recipes from the network
    func populateRecipes() async {
        do {
            let result = try await recipeService.fetchRecipe()
            recipes = result
        } catch {
            print("Failed to fetch recipes: \(error.localizedDescription)")
            caughtError = true
        }
    }
    
    func getImageFromCache(url: String) -> UIImage? {
        if let cachedImage = cache.getImage(key: url) {
            return cachedImage
        } else {
            return nil
        }
    }
    
    // we use this function to grab images from network
    func getImageFromNetwork(url:String) async -> UIImage? {
        do {
            let fetchedImage = try await recipeService.fetchImage(urlString: url)
            return fetchedImage
        } catch {
            print("Failed to fetch image for URL \(url): \(error.localizedDescription)")
            return nil
        }
    }
    
    func addImageToCache(image: UIImage, key: String) {
        cache.addImage(image: image, imageURL: key)
    }
    
}

