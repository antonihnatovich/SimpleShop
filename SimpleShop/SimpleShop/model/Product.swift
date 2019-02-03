//
//  Product.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import Foundation
import CoreData

class Product: NSManagedObject, Decodable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }
    
    @NSManaged public var descr: String?
    @NSManaged public var id: String
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var price: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name
        case price
        case image
        case descr = "description"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Product", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.id = try! container.decode(String.self, forKey: .id)
        self.name = try! container.decode(String.self, forKey: .name)
        self.image = try! container.decode(String.self, forKey: .image)
        self.price = try! container.decode(Double.self, forKey: .price)
        self.descr = try! container.decodeIfPresent(String.self, forKey: .descr)
    }
}
