//
//  ProductsListViewModel.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation

protocol ProductsListViewModelProtocol: class {
    var productPack: ProductPack? { get }
    
    var presentProgress: ((Bool) -> Void)? { get set }
    var updateUI: (() -> Void)? { get set }
    var showError: ((Error?) -> Void)? { get set }
    var presentDetail: ((String) -> Void)? { get set }
    
    func loadItems()
    func itemsCount() -> Int
    func item(at index: Int) -> ProductProtocol?
    func didSelectItem(at index: Int)
}

class ProductsListViewModel: ProductsListViewModelProtocol {
    
    private(set) var productPack: ProductPack? {
        didSet {
            updateUI?()
        }
    }
    
    var presentProgress: ((Bool) -> Void)?
    var updateUI: (() -> Void)?
    var showError: ((Error?) -> Void)?
    var presentDetail: ((String) -> Void)?
    
    func loadItems() {
        presentProgress?(true)
        ProductService.shared.loadAllItems(succeed: { [weak self] pack in
            self?.productPack = pack
            self?.presentProgress?(false)
            }, errored: { [weak self] error in
                self?.showError?(error)
                self?.presentProgress?(false)
        })
    }
    
    func itemsCount() -> Int {
        return productPack?.products.count ?? 0
    }
    
    func item(at index: Int) -> ProductProtocol? {
        return productPack?.products[index]
    }
    
    func didSelectItem(at index: Int) {
        guard let id = item(at: index)?.id else { return }
        presentDetail?(id)
    }
}
