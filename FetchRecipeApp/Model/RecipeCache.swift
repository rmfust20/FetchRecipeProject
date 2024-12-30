
import Foundation
import UIKit

class RecipeCache{
    static let instance = RecipeCache()
    private init () {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        return cache
    }()
    
    func addImage(image: UIImage, imageURL: String) {
        imageCache.setObject(image, forKey: imageURL as NSString)
    }
    
    func getImage(key:String) -> UIImage? {
        if let result = imageCache.object(forKey: key as NSString){
            return result
        } else {
            return nil
        }
    }
    
}
