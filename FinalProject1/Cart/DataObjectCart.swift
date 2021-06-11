//
//  DataObjectCart.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 18.05.2021.
//

import UIKit
import RealmSwift

@objcMembers
class ProductData: Object{
    dynamic var image = ""
    dynamic var name = ""
    dynamic var size = ""
    dynamic var color = ""
    dynamic var price = 0
}

class Persistence{
    static let shared = Persistence()
    let realm = try! Realm()
    
    func save(item: ProductData){
        try! realm.write{
            realm.add(item)
        }
    }
    
    func getItems() -> Results<ProductData>{
        return realm.objects(ProductData.self)
    }
    
    func remove(index: Int){
        let item = realm.objects(ProductData.self)[index]
        try! realm.write{
            realm.delete(item)
        }
    }
    
    func removeAll(){
        try! realm.write{
            realm.deleteAll()
        }
    }
}
