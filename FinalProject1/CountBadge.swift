//
//  CountBadge.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 01.07.2021.
//

import UIKit

class CountBadge{
    var currentCount = 0
    var count = 0
    static let shared = CountBadge()
    func updateCount() -> Int{
        count = 0
        for i in Persistence.shared.getItems(){
            count += i.count
        }
        return count
    }
}
