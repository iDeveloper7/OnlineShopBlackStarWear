//
//  Subcategory.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 07.06.2021.
//

import Foundation

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
