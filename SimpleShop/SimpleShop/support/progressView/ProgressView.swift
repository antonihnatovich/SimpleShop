//
//  ProgressView.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        contentView.cornerRadius = 10
        cornerRadius = 30
        addShadow(color: .gray, offset: CGSize(width: 0, height: 0), radius: 10, opacity: 0.1)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ProgressView", bundle: .main)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func present(with title: String, animated: Bool) {
        self.isHidden = true
        activityIndicator.startAnimating()
        guard animated else {
            alpha = 1.0
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1.0
        })
    }
    
    func hide(animated: Bool) {
        activityIndicator.stopAnimating()
        guard animated else {
            alpha = 0
            isHidden = true
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        })
    }
}
