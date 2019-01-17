//
//  Constants.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation

enum Progress: String {
    case updating = "Updating..."
}

enum Cell: String {
    case productCell = "ProductCollectionViewCell"
}

enum Endpoint {
    case base
    case listPart
    case detailPart(String)
    
    var path: String {
        switch self {
        case .base:
            return "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/"
        case .listPart:
            return Endpoint.base.path + "list"
        case .detailPart(let id):
            return Endpoint.base.path + "\(id)/detail"
        }
    }
    
    var url: URL? {
        return URL(string: path)
    }
}
