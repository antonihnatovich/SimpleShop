//
//  ProductService.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/17/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import SystemConfiguration
import CoreData

protocol ProductServiceProtocol: class {
    typealias ServiceError = ((Error?) -> Void)
    
    func loadAllItems(succeed: @escaping (([Product]?) -> Void), errored: @escaping ServiceError)
    func productDetailed(for id: String, succeed: @escaping ((Product?) -> Void), errored: @escaping ServiceError)
}

class ProductService: ProductServiceProtocol {

    static let shared = ProductService()
    private lazy var coreDataHelper: CoreDataHelper = {
        return CoreDataHelper.shared
    }()
    private init() {}
    
     func loadAllItems(succeed: @escaping (([Product]?) -> Void), errored: @escaping ServiceError) {
        guard let url = Endpoint.listPart.url else { return }
        guard NetworkChecker.isNetworkReachable() else {
            succeed(coreDataHelper.fetchAllProducts())
            errored(NetworkError.noInternet)
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errored(NetworkError.badResponse)
                }
                return
            }
            
            do {
                let context = self?.coreDataHelper.persistantContainer.viewContext
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = context
                _ = try decoder.decode([Product].self, from: data)
                context?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try? context?.save()
                DispatchQueue.main.async {
                    succeed(self?.coreDataHelper.fetchAllProducts())
                }
            } catch {
                DispatchQueue.main.async {
                    errored(NetworkError.badResponse)
                }
            }
        })
        task.resume()
    }
    
    func productDetailed(for id: String, succeed: @escaping ((Product?) -> Void), errored: @escaping ServiceError) {
        guard let url = Endpoint.detailPart(id).url else { return }
        guard NetworkChecker.isNetworkReachable() else {
            errored(NetworkError.noInternet)
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    succeed(self?.coreDataHelper.concreteProduct(with: id))
                    errored(NetworkError.badResponse)
                }
                return
            }
            
            do {
                let context = self?.coreDataHelper.persistantContainer.viewContext
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = context
                _ = try decoder.decode(Product.self, from: data)
                try? context?.save()
                DispatchQueue.main.async {
                    succeed(self?.coreDataHelper.concreteProduct(with: id))
                }
            } catch let decodingError {
                Swift.print(decodingError.localizedDescription)
                DispatchQueue.main.async {
                    succeed(self?.coreDataHelper.concreteProduct(with: id))
                    errored(NetworkError.badResponse)
                }
            }
        })
        task.resume()
    }
}
