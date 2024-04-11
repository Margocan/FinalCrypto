//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//

import Foundation

class Crypto: Codable {
    let asset_id: String?
    let name:String?
    let price_usd:Float?
    let id_icon: String?
    var imageUrl: String?
    
    var isFavorite: Bool? = false

    
    init(asset_id: String?, name: String?, price_usd: Float?, id_icon: String?, imageUrl: String? = nil, isFavorite: Bool? = false) {
        self.asset_id = asset_id
        self.name = name
        self.price_usd = price_usd
        self.id_icon = id_icon
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
    }
}
