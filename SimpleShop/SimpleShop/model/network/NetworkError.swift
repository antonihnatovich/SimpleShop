//
//  NetworkError.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case badResponse
    
    var localizedDescription: String {
        switch self {
        case .noInternet:
            return NSLocalizedString("network.error.noInternet", comment: "")
        case .badResponse:
            return NSLocalizedString("network.error.badRequest", comment: "")
        }
    }
}
