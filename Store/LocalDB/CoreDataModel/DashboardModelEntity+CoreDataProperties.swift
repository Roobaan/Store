//
//  DashboardModelEntity+CoreDataProperties.swift
//  Store
//
//  Created by SCT on 31/05/24.
//
//

import Foundation
import CoreData


extension DashboardModelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DashboardModelEntity> {
        return NSFetchRequest<DashboardModelEntity>(entityName: "DashboardModelEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var hasCategory: NSSet?
    @NSManaged public var hasCardOffer: NSSet?
    @NSManaged public var hasProduct: NSSet?

}

// MARK: Generated accessors for hasCategory
extension DashboardModelEntity {

    @objc(addHasCategoryObject:)
    @NSManaged public func addToHasCategory(_ value: CategoryEntity)

    @objc(removeHasCategoryObject:)
    @NSManaged public func removeFromHasCategory(_ value: CategoryEntity)

    @objc(addHasCategory:)
    @NSManaged public func addToHasCategory(_ values: NSSet)

    @objc(removeHasCategory:)
    @NSManaged public func removeFromHasCategory(_ values: NSSet)

}

// MARK: Generated accessors for hasCardOffer
extension DashboardModelEntity {

    @objc(addHasCardOfferObject:)
    @NSManaged public func addToHasCardOffer(_ value: CardOfferEntity)

    @objc(removeHasCardOfferObject:)
    @NSManaged public func removeFromHasCardOffer(_ value: CardOfferEntity)

    @objc(addHasCardOffer:)
    @NSManaged public func addToHasCardOffer(_ values: NSSet)

    @objc(removeHasCardOffer:)
    @NSManaged public func removeFromHasCardOffer(_ values: NSSet)

}

// MARK: Generated accessors for hasProduct
extension DashboardModelEntity {

    @objc(addHasProductObject:)
    @NSManaged public func addToHasProduct(_ value: ProductEntity)

    @objc(removeHasProductObject:)
    @NSManaged public func removeFromHasProduct(_ value: ProductEntity)

    @objc(addHasProduct:)
    @NSManaged public func addToHasProduct(_ values: NSSet)

    @objc(removeHasProduct:)
    @NSManaged public func removeFromHasProduct(_ values: NSSet)

}

extension DashboardModelEntity : Identifiable {

}
