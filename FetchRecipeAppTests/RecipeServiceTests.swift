import XCTest
@testable import FetchRecipeApp

final class RecipeServiceTests: XCTestCase {
    
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
        do {
            let recipeList = try await recipeServicePass.fetchRecipe()
            XCTAssert(!recipeList.isEmpty)
        }
        catch {
            XCTFail()
        }
    }
    
    func testEmptyRecipes() async throws {
        do {
            let recipeList = try await recipeServiceMissing.fetchRecipe()
            XCTAssert(recipeList.isEmpty)
        }
        catch {
           XCTFail()
        }
    }
    
    func testMalformedRecipes() async throws {
        do {
            let recipeList = try await recipeServiceMalformed.fetchRecipe()
            XCTFail()
        }
        catch {
            // this is passing since we want to catch an error
        }
    }
    
    func testNoURLFetchImage() async throws {
        do {
            let url = ""
            let imageResult = try await recipeServicePass.fetchImage(urlString: url)
            XCTFail()
        }
        catch {
            // this is passing because we want image decode to fail
        }
    }
    
    func testNoImageFetchImage() async throws {
        do {
            let url = "https://www.netflix.com/browse"
            let imageResult = try await recipeServicePass.fetchImage(urlString: url)
            XCTFail()
        }
        catch {
            // this is passing because we want decode to fail
        }
    }
    
    func testValidImageFetchImage() async throws {
        do {
            let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Peacock_Plumage.jpg/440px-Peacock_Plumage.jpg"
            let imageRequest = try await recipeServicePass.fetchImage(urlString: url)
        }
        catch {
            XCTFail()
        }
    }
}

