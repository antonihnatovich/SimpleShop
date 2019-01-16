//
//  ProductListViewController.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private(set) var viewModel: ProductsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProductsListViewModel()
        viewModel.updateUI = { [weak self] in
            self?.collectionView.reloadData()
        }
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: Constants.cellIdentifier)
    }
    
    private class Constants {
        static let cellPadding: CGFloat = 16
        static let cellIdentifier = "ProductCollectionViewCell"
    }
}

// MARK: UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        if let item = viewModel.item(at: indexPath.row) {
            cell.update(with: item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount()
    }
}

// MARK: UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calculatedCellsSummaryEdgeLength = (collectionView.frame.size.width - Constants.cellPadding) / 2
        return CGSize(width: calculatedCellsSummaryEdgeLength, height: calculatedCellsSummaryEdgeLength)
    }
}
