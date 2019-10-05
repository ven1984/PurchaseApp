//
//  HomeViewModeling.swift
//  PurchaseApp
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import RxCocoa

enum PurchaseState {
    case error(PurchaseError)
    case success
}

protocol HomeViewModeling {
    
    var purchaseState: Signal<PurchaseState> { get }
    
    func purchase()
    func restore()
}
