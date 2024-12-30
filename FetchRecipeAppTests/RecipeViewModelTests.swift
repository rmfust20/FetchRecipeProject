import XCTest
@testable import FetchRecipeApp

final class RecipeViewModelTests: XCTestCase {
    
    var recipeServicePass: RecipeService!
    var recipeServiceMissing: RecipeService!
    var recipeServiceMalformed: RecipeService!
    
    
    override func setUpWithError() throws {
        recipeServicePass = RecipeService(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        recipeServiceMissing = RecipeService(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json" )
        recipeServiceMalformed = RecipeService(url:  "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
    }
    
    override func tearDownWithError() throws {
        recipeServicePass = nil
        recipeServiceMissing = nil
        recipeServiceMalformed = nil
    }
    
    func testValidRecipes() async throws {
        let recipeViewModel = RecipeViewModel(recipeService: recipeServicePass)
        await recipeViewModel.populateRecipes()
        XCTAssert(!recipeViewModel.recipes.isEmpty)
    }
    
    func testEmptyRecipes() async throws {
        let recipeViewModel = RecipeViewModel(recipeService: recipeServiceMissing)
        await recipeViewModel.populateRecipes()
        XCTAssert(recipeViewModel.recipes.isEmpty)
    }
    
    func testMalformedRecipes() async throws {
        let recipeViewModel = RecipeViewModel(recipeService: recipeServiceMalformed)
        await recipeViewModel.populateRecipes()
        XCTAssert(recipeViewModel.caughtError == true)
    }
    
    func testNoURLFetchImage() async throws {
        let url = ""
        let recipeViewModel = RecipeViewModel(recipeService: recipeServicePass)
        if let networkImage = await recipeViewModel.getImageFromNetwork(url: url) {
            XCTFail()
        }
    }
    
    func testNoImageFetchImage() async throws {
        let url = "https://www.netflix.com/browse"
        let recipeViewModel = RecipeViewModel(recipeService: recipeServicePass)
        if let networkImage = await recipeViewModel.getImageFromNetwork(url: url) {
            XCTFail()
        }
    }
    
    func testValidImageFetchImage() async throws {
        let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Peacock_Plumage.jpg/440px-Peacock_Plumage.jpg"
        let recipeViewModel = RecipeViewModel(recipeService: recipeServicePass)
        if let networkImage = await recipeViewModel.getImageFromNetwork(url: url) {
            
        }
        else {
            XCTFail()
        }
    }
    
    func testAddImageToCache() {
        let recipeViewModel = RecipeViewModel(recipeService: recipeServicePass)
        if let myImage = UIImage(systemName: "figure") {
            recipeViewModel.addImageToCache(image: myImage, key: "figure")
            if let cachedImage = recipeViewModel.getImageFromCache(url: "figure") {

            }
            else {
                XCTFail()
            }
        }
    }
    
    func testGetImageFromCache() {
        let recipeViewModel = RecipeViewModel(recipeService: recipeServicePass)
        if let cachedImage = recipeViewModel.getImageFromCache(url: "Bogus") {
            // fail here because there should be no image
            XCTFail()
        }
    }
}


