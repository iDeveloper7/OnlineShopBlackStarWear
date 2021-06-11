//
//  Category.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 07.06.2021.
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
