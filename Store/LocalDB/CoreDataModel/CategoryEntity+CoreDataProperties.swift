//
//  CategoryEntity+CoreDataProperties.swift
//  Store
//
//  Created by SCT on 31/05/24.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var layout: String?
    @NSManaged public var name: String?
    @NSManaged public var belongsToModel: DashboardModelEntity?

}

extension CategoryEntity : Identifiable {

}
