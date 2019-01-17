//
//  ImageService.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    private static let cache: NSCache = NSCache<NSString, UIImage>()
    
    class func downloadImage(with path: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: path) else { completion(nil); return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            var image: UIImage?
            
            if let data = data {
                image = UIImage(data: data)
            }
            
            if let image = image {
                cache.setObject(image, forKey: NSString(string: url.absoluteString))
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        })
        task.resume()
    }
    
    class func requestImage(with path: String, completion: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: NSString(string: path)) {
            completion(image)
        } else {
            downloadImage(with: path, completion: completion)
        }
    }
}
