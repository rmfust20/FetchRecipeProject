import XCTest
@testable import FetchRecipeApp

final class RecipeCacheTests: XCTestCase {
    
    private let cache = RecipeCache.instance
    
    func testAddImage() {
        if let myImage = UIImage(systemName: "play") {
            cache.addImage(image: myImage, imageURL: "play")
            if let cachedImage = cache.getImage(key: "play") {
            }
            else {
                XCTFail()
            }
        }
    }
    
    func testGetImage() {
        if let cachedImage = cache.getImage(key: "bogus") {
            // fail here because there should be no image
            XCTFail()
        }
    }
}

