//
//  ProductService.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation

protocol ProductServiceProtocol: class {
    
    func loadAllItems(succeed: @escaping ((ProductPack?) -> Void), errored: @escaping((Error?) -> Void))
}

class ProductService: ProductServiceProtocol {
    
    static let shared = ProductService()
    
     func loadAllItems(succeed: @escaping ((ProductPack?) -> Void), errored: @escaping((Error?) -> Void)) {
        guard let url = Endpoint.listPart.url else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errored(error)
                }
                return
            }
            
            do {
                let productsPack: ProductPack? = try JSONDecoder().decode(ProductPack.self, from: data)
                DispatchQueue.main.async {
                    succeed(productsPack)
                }
            } catch let decodingError {
                Swift.print(decodingError.localizedDescription)
                errored(decodingError)
            }
        })
        task.resume()
    }
}
