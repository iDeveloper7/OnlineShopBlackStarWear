//
//  URLS.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 30.03.2021.
//

import Foundation

struct Urls{
    static func urlCategory() -> String{
        return "http://blackstarshop.ru/index.php?route=api/v1/categories"
    }
    static func urlProducts(id: Int) -> String{
        return "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(id)"
    }
    
    static func url() -> String{
        return "http://blackstarshop.ru/"
    }
}
