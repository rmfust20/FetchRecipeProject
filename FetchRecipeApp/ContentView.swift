import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var recipeViewModel = RecipeViewModel(recipeService: RecipeService(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"))
    @State var recipeDict: [String: UIImage] = [:]
    
    var body: some View {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack {
                    Text("My Recipes")
                        .font(.largeTitle)
                        .underline()
                    
                    if recipeViewModel.caughtError {
                        ErrorView()
                    }
                    
                    if recipeViewModel.recipes.isEmpty {
                        Text("No recipes")
                            .font(.title)
                            .padding()
                    }
                    List {
                        ForEach(recipeViewModel.recipes) { recipe in
                            HStack {
                                if let validURL = recipe.photo_url_small {
                                    if let cachedImage = recipeViewModel.getImageFromCache(url: validURL) {
                                        // Display the cached image
                                        Image(uiImage: cachedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                    } else {
                                        // Placeholder while fetching
                                        if let recipeDictImage = recipeDict[validURL] {
                                            Image(uiImage: recipeDictImage)
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
                        Task {
                            await recipeViewModel.populateRecipes()
                            //recipeDict.removeAll() // Clear cache if necessary
                        }
                    }
                    .padding()
                    .onAppear {
                        Task {
                            await recipeViewModel.populateRecipes()
                        }
                    }
                }
            }
        }
    }

#Preview {
    ContentView()
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

