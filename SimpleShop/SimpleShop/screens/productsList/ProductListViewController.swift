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
    @IBOutlet weak var progressView: ProgressView!
    private(set) var viewModel: ProductsListViewModel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProductsListViewModel()
        bindViewModel()
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: Cell.productCell.rawValue)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    deinit {
        Swift.print("[ProductListViewController] deinit")
    }
    
    private func bindViewModel() {
        
        viewModel.updateUI = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.showError = { [weak self] error in
            self?.showError(title: "Error", message: error?.localizedDescription ?? "Unrecognized error acquired")
        }
        
        viewModel.presentProgress = { [weak self] state in
            if state {
                self?.progressView.present(with: Progress.updating.rawValue, animated: true)
            } else {
                self?.progressView.hide(animated: true)
            }
        }
    }
    
    private class Constants {
        static let cellPadding: CGFloat = 20
        static let visibleCellColumns: CGFloat = 2
        static let visibleCellRows: CGFloat = 2.5
    }
}

// MARK: UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.productCell.rawValue, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
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
        let calculatedWidth = (collectionView.frame.size.width - Constants.cellPadding) / Constants.visibleCellColumns
        let calculatedHeight = (collectionView.frame.size.height - Constants.cellPadding) / Constants.visibleCellRows
        return CGSize(width: calculatedWidth, height: calculatedHeight)
    }
}
