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
    typealias RequestedImage = (String, UIImage?) -> Void
    
    func downloadImage(with url: URL, completion: @escaping RequestedImage)
    func requestImage(with path: String, completion: @escaping RequestedImage)
}

class ImageService: ImageServiceProtocol {
    
    private let cache: NSCache = NSCache<NSString, UIImage>()
    private let deviceCacheService = DeviceCacheService.shared
    
    static let shared = ImageService()
    private init() {}
    
    func downloadImage(with url: URL, completion: @escaping RequestedImage) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            var image: UIImage?
            
            if let data = data {
                image = UIImage(data: data)
            }
            
            if let image = image {
                self?.saveImageToCache(with: url, and: image)
            }
            
            DispatchQueue.main.async {
                completion(url.absoluteString, image)
            }
        })
        task.resume()
    }
    
    func requestImage(with path: String, completion: @escaping RequestedImage) {
        guard let url = URL(string: path) else { completion(path, nil); return }
        
        if let image = retrieveImageFromCache(with: url) {
            completion(path, image)
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
        if let imageFromLocalStore = deviceCacheService.imageFromDevice(imageURL: path) {
            cache.setObject(imageFromLocalStore, forKey: NSString(string: path.absoluteString))
            return imageFromLocalStore
        }
        return nil
    }
}
