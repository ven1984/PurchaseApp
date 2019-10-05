//
//  HomeViewModeling.swift
//  PurchaseApp
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import RxCocoa

enum PurchaseState {
    case none
    case error(PurchaseError)
    case success
}

protocol HomeViewModeling {
    
    var purchaseState: Driver<PurchaseState> { get }
    
    func purchase()
    func restore()
}
