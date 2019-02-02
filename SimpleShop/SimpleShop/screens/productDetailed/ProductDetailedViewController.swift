//
//  ProductDetailedViewController.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import UIKit

class ProductDetailedViewController: UIViewController {
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var progressView: ProgressView!
    
    var productId: String?
    private var product: Product? {
        didSet {
            updateUI(with: product)
        }
    }
    private var viewModel: ProductDetailedViewModel?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = productId else { return }
        viewModel = ProductDetailedViewModel(with: id)
        bindViewModel()
    }
    
    deinit {
        Swift.print("[ProductDetailedViewController] deinit")
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.updateUI = { [weak self] product in
            self?.retryButton.isHidden = true
            self?.updateUI(with: product)
        }
        
        viewModel.showError = { [weak self] error in
            if let err = error as? NetworkError, err == .noInternet {
                self?.retryButton.isHidden = false
            }
            self?.showError(title: NSLocalizedString("alert.error.title", comment: ""), message: (error as? NetworkError)?.localizedDescription ?? NSLocalizedString("error.unrecognizedError", comment: ""))
        }
        
        viewModel.presentProgress = { [weak self] state in
            UIApplication.shared.isNetworkActivityIndicatorVisible = state
            if state {
                self?.progressView.present(with: Progress.updating.rawValue, animated: true)
            } else {
                self?.progressView.hide(animated: true)
            }
        }
        viewModel.getDetailedItem()
    }
    
    private func updateUI(with product: ProductProtocol?) {
        guard let product = product else {
            productImageView.image = nil
            productDescriptionLabel.text = nil
            productTitleLabel.text = nil
            title = nil
            return
        }
        
        ImageService.shared.requestImage(with: product.image, completion: { [weak self] image in
            self?.productImageView.image = image
        })
        productTitleLabel.text = product.name
        productDescriptionLabel.text = product.description
        title = product.name
    }
    
    // MARK: IBActions
    @IBAction func reloadButtonDidPress(_ sender: UIButton) {
        viewModel?.getDetailedItem()
    }
}
