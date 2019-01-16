//
//  Product.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import UIKit

struct Product: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name
        case price
        case image
    }
    
    var id: String
    var name: String
    var price: Double
    var image: String
}

struct ProductPack: Decodable {
    var products: [Product]
}
