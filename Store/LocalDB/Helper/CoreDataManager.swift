//
//  CoreDataManager.swift
//  Store
//
//  Created by SCT on 30/05/24.
//

import Foundation
import CoreData

class CoreDataHandler {
    
    static let shared = CoreDataHandler()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Store") // Replace with your model name
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func clearCoreData() {
            let entities = persistentContainer.managedObjectModel.entities
            for entity in entities {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try context.execute(deleteRequest)
                    saveContext()
                } catch let error as NSError {
                    print("Failed to clear Core Data for entity \(entity.name!): \(error), \(error.userInfo)")
                }
            }
        }
    // Save context
        func saveContext () {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    func saveDashboardModel(_ dashboardModel: DashboardModel) {
        let context = persistentContainer.viewContext
        clearCoreData()
        let dashboardEntity = DashboardModelEntity(context: context)
        
        // Save categories
        if let categories = dashboardModel.category {
            let categoryEntities = categories.map { category -> CategoryEntity in
                let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", category.id ?? "")
                let categoryEntity: CategoryEntity
                
                if let existingCategory = try? context.fetch(fetchRequest).first {
                   print("Category check existing")
                    print(existingCategory.name)
                    categoryEntity = existingCategory
                } else {
                    categoryEntity = CategoryEntity(context: context)
                }
                
                categoryEntity.id = category.id
                categoryEntity.name = category.name
                categoryEntity.layout = category.layout
                return categoryEntity
            }
            dashboardEntity.hasCategory = NSSet(array: categoryEntities)
        }
        
        // Save card offers
        if let cardOffers = dashboardModel.card_offers {
            let cardOfferEntities = cardOffers.map { cardOffer -> CardOfferEntity in
                let fetchRequest: NSFetchRequest<CardOfferEntity> = CardOfferEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", cardOffer.id ?? "")
                let cardOfferEntity: CardOfferEntity
                
                if let existingCardOffer = try? context.fetch(fetchRequest).first {
                    cardOfferEntity = existingCardOffer
                } else {
                    cardOfferEntity = CardOfferEntity(context: context)
                }
                
                cardOfferEntity.id = cardOffer.id
                cardOfferEntity.percentage = cardOffer.percentage ?? 0.0
                cardOfferEntity.card_name = cardOffer.card_name
                cardOfferEntity.offer_desc = cardOffer.offer_desc
                cardOfferEntity.max_discount = cardOffer.max_discount
                cardOfferEntity.image_url = cardOffer.image_url
                return cardOfferEntity
            }
            dashboardEntity.hasCardOffer = NSSet(array: cardOfferEntities)
        }
        
        // Save products
        if let products = dashboardModel.products {
            let productEntities = products.map { product -> ProductEntity in
                let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")
                let productEntity: ProductEntity
                
                if let existingProduct = try? context.fetch(fetchRequest).first {
                    productEntity = existingProduct
                } else {
                    productEntity = ProductEntity(context: context)
                }
                
                productEntity.id = product.id
                productEntity.name = product.name
                productEntity.rating = product.rating ?? 0.0
                productEntity.review_count = Int64(product.review_count ?? 0)
                productEntity.price = product.price ?? 0.0
                productEntity.category_id = product.category_id
                productEntity.image_url = product.image_url
                productEntity.descriptionPro = product.description
                productEntity.card_offer_ids = product.card_offer_ids
                productEntity.colors = product.colorsAvailable
                return productEntity
            }
            dashboardEntity.hasProduct = NSSet(array: productEntities)
        }
        
        // Save the context
        do {
            try context.save()
            print("Dashboard model saved successfully.")
        } catch {
            print("Failed to save dashboard model: \(error)")
        }
    }

    
    func fetchDashboardModel() -> DashboardModel? {
        let fetchRequest: NSFetchRequest<DashboardModelEntity> = DashboardModelEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            if let dashboardEntity = results.first {
                // Map properties from dashboardEntity to DashboardModel
                return DashboardModel(
                    category: fetchCategories(for: dashboardEntity)?.sorted(by: { $0.id ?? "0" < $1.id ?? "0" }),
                    card_offers: fetchCardOffers(for: dashboardEntity),
                    products: fetchProducts(for: dashboardEntity)?.sorted(by: { $0.id ?? "0" < $1.id ?? "0" })
                )
            }
            
        } catch {
            print("Failed to fetch dashboard model: \(error)")
        }
        return nil
    }
    
    private func fetchCategories(for dashboardEntity: DashboardModelEntity) -> [Category]? {
        guard let categoryEntities = dashboardEntity.hasCategory as? Set<CategoryEntity> else { return nil }
        return categoryEntities.map { categoryEntity in
            return Category(
                id: categoryEntity.id,
                name: categoryEntity.name,
                layout: categoryEntity.layout
            )
        }
    }
    
    private func fetchCardOffers(for dashboardEntity: DashboardModelEntity) -> [Card_offers]? {
        guard let cardOfferEntities = dashboardEntity.hasCardOffer as? Set<CardOfferEntity> else { return nil }
        return cardOfferEntities.map { cardOfferEntity in
            return Card_offers(
                id: cardOfferEntity.id,
                percentage: cardOfferEntity.percentage,
                card_name: cardOfferEntity.card_name,
                offer_desc: cardOfferEntity.offer_desc,
                max_discount: cardOfferEntity.max_discount,
                image_url: cardOfferEntity.image_url
            )
        }
    }
    
    private func fetchProducts(for dashboardEntity: DashboardModelEntity) -> [Products]? {
        guard let productEntities = dashboardEntity.hasProduct as? Set<ProductEntity> else { return nil }
        return productEntities.map { productEntity in
            return Products(
                id: productEntity.id,
                name: productEntity.name,
                rating: productEntity.rating,
                review_count: Int(productEntity.review_count),
                price: productEntity.price,
                category_id: productEntity.category_id,
                card_offer_ids: productEntity.card_offer_ids,
                image_url: productEntity.image_url,
                description: productEntity.descriptionPro,
                colorsAvailable: productEntity.colors
                
            )
        }
    }
}

@objc(NSStringTransformer)
class NSStringTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [NSString.self]
    }
}


 
