//
//  ProductLoader.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 30.03.2021.
//

import Foundation
import Alamofire

class ProductLoader {
    func loadProducts(url: String, completion: @escaping ([Product]) -> Void){
        AF.request(url).responseJSON { (response) in
            if let object = response.value,
               let jsonDict = object as? NSDictionary{
                var product = [Product]()
                for (_, data) in jsonDict where data is NSDictionary{
                    if let prod = Product(data: data as! NSDictionary){
                        product.append(prod)
                    }
                }
                DispatchQueue.main.async {
                    completion(product.sorted(by: {$0.sortOrder < $1.sortOrder}))
                }
            }
        }
    }
}
