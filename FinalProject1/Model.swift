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
