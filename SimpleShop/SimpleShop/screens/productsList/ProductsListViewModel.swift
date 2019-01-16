//
//  ProductsListViewModel.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import UIKit

protocol ProductsListViewModelProtocol: class {
    var updateUI: (() -> Void)? { get set }
    
    func loadItems()
    func itemsCount() -> Int
    func item(at index: Int) -> Product?
    func didSelectItem(at index: Int)
}

class ProductsListViewModel: ProductsListViewModelProtocol {
    
    var productPack: ProductPack? {
        didSet {
            updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        guard let url = URL(string: "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/list") else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            let products = try! JSONDecoder().decode(ProductPack.self, from: data)
            DispatchQueue.main.async {
                self?.productPack = products
            }
        })
        task.resume()
    }
    
    func itemsCount() -> Int {
        return productPack?.products.count ?? 0
    }
    
    func item(at index: Int) -> Product? {
        return productPack?.products[index]
    }
    
    func didSelectItem(at index: Int) {
        
    }
}
