//
//  ProductService.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol ProductServiceProtocol: class {
    
    func loadAllItems(succeed: @escaping ((ProductPack?) -> Void), errored: @escaping((Error?) -> Void))
}

class ProductService: ProductServiceProtocol {
    
    
    
    static let shared = ProductService()
    
     func loadAllItems(succeed: @escaping ((ProductPack?) -> Void), errored: @escaping((Error?) -> Void)) {
        guard let url = Endpoint.listPart.url else { return }
        guard NetworkChecker.isNetworkReachable() else {
            errored(NetworkError.noInternet)
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errored(NetworkError.badResponse)
                }
                return
            }
            
            do {
                let productsPack: ProductPack? = try JSONDecoder().decode(ProductPack.self, from: data)
                DispatchQueue.main.async {
                    succeed(productsPack)
                }
            } catch {
                errored(NetworkError.badResponse)
            }
        })
        task.resume()
    }
    
    func productDetailed(for id: String, succeed: @escaping ((ProductProtocol?) -> Void), errored: @escaping((Error?) -> Void)) {
        guard let url = Endpoint.detailPart(id).url else { return }
        guard NetworkChecker.isNetworkReachable() else {
            errored(NetworkError.noInternet)
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errored(NetworkError.badResponse)
                }
                return
            }
            
            do {
                let products: ProductProtocol? = try JSONDecoder().decode(Product.self, from: data)
                DispatchQueue.main.async {
                    succeed(products)
                }
            } catch let decodingError {
                Swift.print(decodingError.localizedDescription)
                errored(NetworkError.badResponse)
            }
        })
        task.resume()
    }
}
