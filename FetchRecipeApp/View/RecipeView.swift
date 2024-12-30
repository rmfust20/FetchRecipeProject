import SwiftUI

import SwiftUI

struct RecipeView: View {
    // recipeViewModel controls our interactions with the network
    @StateObject var recipeViewModel = RecipeViewModel(recipeService: RecipeService(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"))
    // recipeDict is a data structure we use as a bridge to the cache
    @State var recipeDict: [String: UIImage] = [:]
    
    var body: some View {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack {
                    Text("My Recipes")
                        .font(.largeTitle)
                        .underline()
                    
                    // check if there was an error in downloading recipes
                    if recipeViewModel.caughtError {
                        ErrorView()
                    }
                    
                    // check if there are no recipes
                    if recipeViewModel.recipes.isEmpty {
                        Text("No recipes")
                            .font(.title)
                            .padding()
                    }
                    
                    // List to display all of the recipes
                    List {
                        //Iterate over the recipes and we will handle their data
                        ForEach(recipeViewModel.recipes) { recipe in
                            HStack {
                                // first we check if the url is not null for each recipe
                                if let validURL = recipe.photo_url_small {
                                    // recipe has a url, now we check if it is already in the cache
                                    if let cachedImage = recipeViewModel.getImageFromCache(url: validURL) {
                                        // Display the cached image
                                        Image(uiImage: cachedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                                            .clipShape(Circle())
                                    } else {
                                        // Image was not already in the cache we need to fetch it and use the Dict as a placeholder
                                        if let recipeDictImage = recipeDict[validURL] {
                                            Image(uiImage: recipeDictImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        } else {
                                            // fetch image from network to put in dict
                                            ProgressView()
                                                .task{
                                                    if let fetchedImage = await recipeViewModel.getImageFromNetwork(url: validURL) {
                                                        recipeDict[validURL] = fetchedImage
                                                        
                                                        recipeViewModel.addImageToCache(image: fetchedImage, key: validURL)
                                                    }
                                                }
                                        }
                                    }
                                }
                                // If there is no image we still see the name
                                // If we get images the name will be displayed next to the image
                                Text(recipe.name)
                                    .font(.headline)
                            }
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundStyle(Color.gray)
                            Divider()
                                .frame(height: 3)
                                .background(Color.black)
                        }
                        .listRowBackground(Color("BackgroundColor"))
                        
                    }
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        // On refresh we check to see if there are any new recipes
                        Task {
                            await recipeViewModel.populateRecipes()
                        }
                    }
                    .padding()
                    .onAppear {
                        // On appear we grab the recipes from the network
                        Task {
                            await recipeViewModel.populateRecipes()
                        }
                    }
                }
            }
        }
    }

#Preview {
    RecipeView()
}



struct ErrorView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Text("An error has occcured")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
                Image("ErrorRobot")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            }
        }
    }
}


