//
//  ImageService.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import UIKit

protocol ImageServiceProtocol: class {
    
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void)
    func requestImage(with path: String, completion: @escaping (UIImage?) -> Void)
}

class ImageService: ImageServiceProtocol {
    
    private let cache: NSCache = NSCache<NSString, UIImage>()
    private let deviceCacheService = DeviceCacheService.shared
    
    static let shared = ImageService()
    private init() {}
    
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            var image: UIImage?
            
            if let data = data {
                image = UIImage(data: data)
            }
            
            if let image = image {
                self?.saveImageToCache(with: url, and: image)
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        })
        task.resume()
    }
    
    func requestImage(with path: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: path) else { completion(nil); return }
        
        if let image = retrieveImageFromCache(with: url) {
            completion(image)
        } else {
            downloadImage(with: url, completion: completion)
        }
    }
}

// MARK: ImageServiceCaching
extension ImageService {
    
    private func saveImageToCache(with url: URL, and image: UIImage) {
        cache.setObject(image, forKey: NSString(string: url.absoluteString))
        deviceCacheService.saveImageOnDevice(with: url, image: image)
    }
    
    private func retrieveImageFromCache(with path: URL) -> UIImage? {
        if let image = cache.object(forKey: NSString(string: path.absoluteString)) {
            return image
        }
        let imageFromLocalStore = deviceCacheService.imageFromDevice(imageURL: path)
        return imageFromLocalStore
    }
}
