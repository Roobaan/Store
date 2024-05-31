//
//  ProductEntity+CoreDataProperties.swift
//  Store
//
//  Created by SCT on 31/05/24.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var category_id: String?
    @NSManaged public var descriptionPro: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var rating: Double
    @NSManaged public var review_count: Int64
    @NSManaged public var card_offer_ids: [String]?
    @NSManaged public var colors: [String]?
    @NSManaged public var belongsToModel: DashboardModelEntity?

}

extension ProductEntity : Identifiable {

}
