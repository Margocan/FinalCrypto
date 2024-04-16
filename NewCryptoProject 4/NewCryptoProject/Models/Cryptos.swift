import Foundation

class Crypto: Codable {
    let assetId: String?
    let name:String?
    let priceUsd:Float?
    let idIcon: String?
    var imageUrl: String?
    
    var isFavorite: Bool? = false

 
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case name
        case priceUsd = "price_usd"
        case idIcon = "id_icon"
        case imageUrl
    }
    
    init(assetId: String?, name: String?, priceUsd: Float?, idIcon: String?, imageUrl: String? = nil, isFavorite: Bool? = false) {
        self.assetId = assetId
        self.name = name
        self.priceUsd = priceUsd
        self.idIcon = idIcon
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
    }
}
