//
//  Product.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 07.06.2021.
//

import Foundation

class Product{
    let name: String
    let sortOrder: Int
    let description: String
    let colorName: String
    let mainImage: String
    let productImages: [ProductImages]
    let offers: [Offers]
    let price: Double
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
              let sortOrder = data["sortOrder"] as? String,
              let description = data["description"] as? String,
              let colorName = data["colorName"] as? String,
              let mainImage = data["mainImage"] as? String,
              let productImages = data["productImages"] as? [NSDictionary],
              let offers = data["offers"] as? [NSDictionary],
              let price = data["price"] as? String else { return nil }
        
        var prodImg = [ProductImages]()
        for image in productImages {
            if let productImg = ProductImages(data: image){
                prodImg.append(productImg)
            }
        }
        
        var offer = [Offers]()
        for item in offers {
            if let off = Offers(data: item){
                offer.append(off)
            }
        }
        
        self.name = name
        self.sortOrder = Int(sortOrder) ?? 0
        self.description = description
        self.colorName = colorName
        self.mainImage = mainImage
        self.productImages = prodImg
        self.offers = offer
        self.price = Double(price) ?? 0
    }
}

class Offers{
    let size: String
    let productOfferID: String
    init?(data: NSDictionary){
        guard let size = data["size"] as? String,
              let productOfferID = data["productOfferID"] as? String else { return nil }
        self.size = size
        self.productOfferID = productOfferID
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
