//
//  DeviceCacheService.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 2/2/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import UIKit

protocol DeviceCacheServiceProtocol: class {
    var usedCacheSize: Double { get }
    
    func saveImageOnDevice(with path: URL, image: UIImage, forceUpdate: Bool)
    func imageFromDevice(imageURL: URL) -> UIImage?
}

class DeviceCacheService: DeviceCacheServiceProtocol {
    var usedCacheSize: Double {
        // TODO: Implement
        return 0
    }
    static let shared = DeviceCacheService()
    private init() {}
    
    func saveImageOnDevice(with path: URL, image: UIImage, forceUpdate: Bool = false) {
        guard let directoryPath = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            Swift.print("[ImageService] failed to retrieve url for cache directory")
            return
        }
        
        let fileName = "cachedImages/" + String(path.path.split(separator: "/").last?.split(separator: ".").first ?? "unknown") + ".png"
        let filePath = directoryPath.appendingPathComponent(fileName)
        guard !FileManager.default.fileExists(atPath: filePath.path) || forceUpdate else {
            Swift.print("[ImageService] image with specified filename already exists, no update required")
            return
        }
        if let imageData = image.pngData() {
            try? imageData.write(to: filePath)
        }
    }
    
    func imageFromDevice(imageURL: URL) -> UIImage? {
        guard let directoryPath = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            Swift.print("[ImageService] failed to retrieve url for cache directory")
            return nil
        }
        
        let fileName = "cachedImages/" + String(imageURL.path.split(separator: "/").last?.split(separator: ".").first ?? "unknown") + ".png"
        let filePath = directoryPath.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: filePath.path)
    
        return image
    }
}
