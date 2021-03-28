//
//  CategoriesLoader.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 21.03.2021.
//

import Foundation
import Alamofire

class CategoriesLoader{
    func loadCategories(completion: @escaping ([Category]) -> Void){
        AF.request("http://blackstarshop.ru/index.php?route=api/v1/categories").responseJSON { (response) in
            if let objects = response.value,
            let jsonDict = objects as? NSDictionary{
                var categories = [Category]()
                for (_, data) in jsonDict where data is NSDictionary{
                    if let category = Category(data: data as! NSDictionary){
                        categories.append(category)
                    }
                }
                DispatchQueue.main.async {
                    completion(categories.sorted(by: {$0.sortOrder < $1.sortOrder}))
                }
            }
        }
    }
}
