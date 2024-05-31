//
//  Model.swift
//  Store
//
//  Created by SCT on 26/05/24.
//

import Foundation

struct DashboardModel : Codable {
//    let id : String = "\(Int.random(in: 1...1000))"
    let category : [Category]?
    let card_offers : [Card_offers]?
    let products : [Products]?

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case card_offers = "card_offers"
        case products = "products"
    }

    init(category: [Category]?, card_offers: [Card_offers]?, products: [Products]?) {
        self.category = category
        self.card_offers = card_offers
        self.products = products
//        self.id = "\(Int.random(in: 1...1000))"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent([Category].self, forKey: .category)
        card_offers = try values.decodeIfPresent([Card_offers].self, forKey: .card_offers)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
//        id = "\(Int.random(in: 1...1000))"
    }
}

struct Products : Codable {
    let id : String?
    let name : String?
    let rating : Double?
    let review_count : Int?
    let price : Double?
    let category_id : String?
    let card_offer_ids : [String]?
    let image_url : String?
    let description : String?
    let colorsAvailable : [String]?
    var isFavourite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case rating = "rating"
        case review_count = "review_count"
        case price = "price"
        case category_id = "category_id"
        case card_offer_ids = "card_offer_ids"
        case image_url = "image_url"
        case description = "description"
        case colorsAvailable = "colors"
    }

    init(id: String?, name: String?, rating: Double?, review_count: Int?, price: Double?, category_id: String?, card_offer_ids: [String]?, image_url: String?, description: String?, colorsAvailable: [String]?) {
        self.id = id
        self.name = name
        self.rating = rating
        self.review_count = review_count
        self.price = price
        self.category_id = category_id
        self.card_offer_ids = card_offer_ids
        self.image_url = image_url
        self.description = description
        self.colorsAvailable = colorsAvailable
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        review_count = try values.decodeIfPresent(Int.self, forKey: .review_count)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        card_offer_ids = try values.decodeIfPresent([String].self, forKey: .card_offer_ids)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        colorsAvailable = try values.decodeIfPresent([String].self, forKey: .colorsAvailable)
    }
}

struct Card_offers : Codable {
    let id : String?
    let percentage : Double?
    let card_name : String?
    let offer_desc : String?
    let max_discount : String?
    let image_url : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case percentage = "percentage"
        case card_name = "card_name"
        case offer_desc = "offer_desc"
        case max_discount = "max_discount"
        case image_url = "image_url"
    }

    init(id: String?, percentage: Double?, card_name: String?, offer_desc: String?, max_discount: String?, image_url: String?) {
        self.id = id
        self.percentage = percentage
        self.card_name = card_name
        self.offer_desc = offer_desc
        self.max_discount = max_discount
        self.image_url = image_url
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        percentage = try values.decodeIfPresent(Double.self, forKey: .percentage)
        card_name = try values.decodeIfPresent(String.self, forKey: .card_name)
        offer_desc = try values.decodeIfPresent(String.self, forKey: .offer_desc)
        max_discount = try values.decodeIfPresent(String.self, forKey: .max_discount)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
    }
}

struct Category : Codable {
    let id : String?
    let name : String?
    let layout : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case layout = "layout"
    }

    init(id: String?, name: String?, layout: String?) {
        self.id = id
        self.name = name
        self.layout = layout
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        layout = try values.decodeIfPresent(String.self, forKey: .layout)
    }
}
