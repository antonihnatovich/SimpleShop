//
//  ProductCollectionViewCell.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    private(set) var currentItem: Product?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.text = ""
        productPriceLabel.text = ""
        currentItem = nil
    }
    
    func update(with product: Product) {
        ImageService.requestImage(with: product.image, completion: { [weak self] image in
            self?.productImageView.image = image
        })
        productNameLabel.text = product.name
        productPriceLabel.text = "\(product.price)"
        currentItem = product
    }
}
