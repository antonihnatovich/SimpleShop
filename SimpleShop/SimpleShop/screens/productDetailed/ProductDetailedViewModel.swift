//
//  ProductDetailedViewModel.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation

protocol ProductDetailedViewModelProtocol: class {
    var product: Product? { get }
    
    var updateUI: ((Product?) -> Void)? { get set }
    var showError: ((Error?) -> Void)? { get set }
    var presentProgress: ((Bool) -> Void)? { get set }
    
    func getDetailedItem()
}

class ProductDetailedViewModel: ProductDetailedViewModelProtocol {
    
    private(set) var product: Product? {
        didSet {
            updateUI?(product)
        }
    }
    
    private var id: String
    
    var updateUI: ((Product?) -> Void)?
    var showError: ((Error?) -> Void)?
    var presentProgress: ((Bool) -> Void)?
    
    init(with id: String) {
        self.id = id
    }
    
     func getDetailedItem() {
        presentProgress?(true)
        ProductService.shared.productDetailed(for: id, succeed: { [weak self] product in
            self?.product = product
            self?.presentProgress?(false)
            }, errored: { [weak self] error in
                self?.showError?(error)
                self?.presentProgress?(false)
        })
    }
}
