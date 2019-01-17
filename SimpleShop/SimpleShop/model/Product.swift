//
//  Product.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import UIKit

struct ProductPack: Decodable {
    private(set) var products: [Product]
}

protocol ProductProtocol {
    var id: String { get }
    var name: String { get }
    var price: Double { get }
    var image: String { get }
    var description: String? { get }
}

struct Product: Decodable, ProductProtocol {
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name
        case price
        case image
        case description
    }
    
    private(set) var id: String
    private(set) var name: String
    private(set) var price: Double
    private(set) var image: String
    private(set) var description: String?
}
