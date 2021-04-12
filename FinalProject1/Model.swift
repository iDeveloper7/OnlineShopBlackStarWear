//
//  Model.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 18.03.2021.
//

import Foundation

class Category{
    let name: String
    let image: String
    let iconImage: String
    let sortOrder: Int
    let subcategories: [Subcategory]
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
        let image = data["image"] as? String,
        let iconImage = data["iconImage"] as? String,
        let sortOrder = data["sortOrder"] as? String,
        let subcategories = data["subcategories"] as? [NSDictionary] else { return nil }
        var subCat = [Subcategory]()
        for data in subcategories{
            if let subCateg = Subcategory(data: data){
                subCat.append(subCateg)
            }
        }
        self.name = name
        self.image = image
        self.iconImage = iconImage
        self.sortOrder = Int(sortOrder) ?? 0
        self.subcategories = subCat
    }
}

class Subcategory {
    let id: Int
    let iconImage: String
    let sortOrder: Int
    let name: String
    let type: String
    
    init?(data: NSDictionary) {
        guard let id = data["id"] as? String,
        let iconImage = data["iconImage"] as? String,
        let sortOrder = data["sortOrder"] as? String,
        let name = data["name"] as? String,
        let type = data["type"] as? String else { return nil }
        self.id = Int(id) ?? 0
        self.name = name
        self.iconImage = iconImage
        self.sortOrder = Int(sortOrder) ?? 0
        self.type = type
    }
}

class Product{
    let name: String
    let sortOrder: Int
//    let article: String
    let description: String
//    let colorName: String
//    let colorImageURL: String
    let mainImage: String
    let productImages: [ProductImages]
//    let offers: [NSDictionary]
//    let recommendedProductIDs: [String]
    let price: Double
//    let oldPrice: Int
//    let tag: String
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
        let sortOrder = data["sortOrder"] as? String,
//        let article = data["article"] as? String,
        let description = data["description"] as? String,
//        let colorName = data["colorName"] as? String,
//        let colorImageURL = data["colorImageURL"] as? String,
        let mainImage = data["mainImage"] as? String,
        let productImages = data["productImages"] as? [NSDictionary],
//        let offers = data["offers"] as? [NSDictionary],
//        let recommendedProductIDs = data["recommendedProductIDs"] as? String,
        let price = data["price"] as? String else { return nil }
//        let oldPrice = data["oldPrice"] as? String,
//        let tag = data["tag"] as? String else { return nil }
        
        var prodImg = [ProductImages]()
        for image in productImages {
            if let productImg = ProductImages(data: image){
                prodImg.append(productImg)
            }
        }
        self.name = name
        self.sortOrder = Int(sortOrder) ?? 0
//        self.article = article
        self.description = description
//        self.colorName = colorName
//        self.colorImageURL = colorImageURL
        self.mainImage = mainImage
        self.productImages = prodImg
//        self.offers = offers
//        self.recommendedProductIDs = [recommendedProductIDs]
        self.price = Double(price) ?? 0
//        self.oldPrice = Int(oldPrice) ?? 0
//        self.tag = tag
    }
}

class ProductImages{
    let imageURL: String
    let sortOrder: Int
    init?(data: NSDictionary){
        guard let imageURL = data["imageURL"] as? String,
        let sortOrder = data["sortOrder"] as? String else { return nil }
        self.imageURL = imageURL
        self.sortOrder = Int(sortOrder) ?? 0
    }
    
    
}
