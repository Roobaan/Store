//
//  CardOfferEntity+CoreDataProperties.swift
//  Store
//
//  Created by SCT on 31/05/24.
//
//

import Foundation
import CoreData


extension CardOfferEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardOfferEntity> {
        return NSFetchRequest<CardOfferEntity>(entityName: "CardOfferEntity")
    }

    @NSManaged public var card_name: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var max_discount: String?
    @NSManaged public var offer_desc: String?
    @NSManaged public var percentage: Double
    @NSManaged public var belondsToModel: DashboardModelEntity?

}

extension CardOfferEntity : Identifiable {

}
