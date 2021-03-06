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
    dynamic var count = 1
}

class Persistence{
    static let shared = Persistence()
    let realm = try! Realm()
    
    func save(item: ProductData){
        let array = Persistence.shared.getItems()
        //если элементы, которые уже находятся в БД равны элементам, которые мы собираемся сохранить
        if let index = array.firstIndex(where: {$0.image == item.image && $0.name == item.name && $0.size == item.size && $0.color == item.color}){
            //то перезаписываем количество товара без сохранения нового элемента
            try! realm.write{
                array[index].count += 1
            }
        } else {
            //в ином случае, сохраняем новый элемент
            try! realm.write{
                realm.add(item)
            }
        }
    }
   
    func getItems() -> Results<ProductData>{
        return realm.objects(ProductData.self)
    }
    
    func remove(index: Int){
        let item = Persistence.shared.getItems()[index]
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
