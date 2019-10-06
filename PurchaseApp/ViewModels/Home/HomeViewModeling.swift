//
//  HomeViewModeling.swift
//  PurchaseApp
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import RxCocoa

enum PurchaseState {
    case advanced
    case intermediate
    case none
    case notSupport
    case error(PurchaseError)
}

extension PurchaseState: Equatable {  }

protocol HomeViewModeling {
    
    var purchaseState: Driver<PurchaseState> { get }
    
    func fetchPurchaseItems()
    func purchaseAdvanced()
    func purchaseIntermediate()
    func restore()
}
