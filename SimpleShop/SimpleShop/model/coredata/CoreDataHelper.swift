//
//  CoreDataHelper.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 2/3/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper: NSObject {
    
    static let shared = CoreDataHelper()
    private override init() { super.init() }
    
    lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores(completionHandler: { (storeDescr, error) in
            if let error = error as NSError? {
                fatalError("Critical: Core Data error - \(error.userInfo)")
            }
        })
        return container
    }()
    
    fileprivate class Constants {
        static let containerName = "SimpleShop"
        static let product = "Product"
    }
}

// MARK: CoreData+ProductList
extension CoreDataHelper {
    
    func fetchAllProducts() -> [Product] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.product)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let products = try persistantContainer.viewContext.fetch(fetchRequest) as! [Product]
            return products
        } catch {
            Swift.print(error)
        }
        return []
    }
    
    func concreteProduct(with id: String) -> Product? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.product)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let product = try persistantContainer.viewContext.fetch(fetchRequest) as! [Product]
            return product.first
        } catch {
            Swift.print(error)
        }
        return nil
    }
}
