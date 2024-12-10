import SwiftUI

struct ContentView: View {
    
    @StateObject var recipeViewModel: RecipeViewModel = RecipeViewModel()
    
    var body: some View {
        Text("My Recipes")
            .font(.largeTitle)
        List {
            ForEach(recipeViewModel.recipes) { recipe in
                
                AsyncImage(url: URL(string: recipe.photo_url_small ?? "Hello")) { phase in
                    if let image = phase.image {
                        HStack {
                            image
                                .resizable()
                                .scaledToFit()
                                
                            Text(recipe.name)
                        }// Displays the loaded image.
                    } else {
                        Text(recipe.name)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            recipeViewModel.populateRecipes()
        }
    }
}

#Preview {
    ContentView()
}

