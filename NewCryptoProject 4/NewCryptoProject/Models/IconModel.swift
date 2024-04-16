import Foundation

struct IconModel: Codable {
    let assetId: String?
    let url: String?
    
        
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case url
    }
}
