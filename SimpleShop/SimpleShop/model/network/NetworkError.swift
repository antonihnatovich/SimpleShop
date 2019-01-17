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
            return "You're not connected to the internet. Please, fix that problem and try again"
        case .badResponse:
            return "Received unexpectable response from server. Please, contact developer"
        }
    }
}
