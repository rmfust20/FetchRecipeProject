import Foundation

struct RecipeModel: Codable, Identifiable{
    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String
    let source_url: String?
    let youtube_url: String?
    
    var id: String {uuid}
}

struct RecipeResponse: Decodable {
    let recipes: [RecipeModel]
}
