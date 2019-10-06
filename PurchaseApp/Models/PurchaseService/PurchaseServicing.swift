//
//  PurchaseServicing.swift
//  PurchaseApp
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import RxSwift
import RxCocoa
import StoreKit

enum PurchaseProductType {
    case none
    case advanced
    case intermediate
}

enum PurchaseError: Error {
    case fail
    case exist
    case timeout
}

protocol PurchaseServicing {
    var productsRelay: BehaviorRelay<[SKProduct]> { get }
    var purchaseRelay: BehaviorRelay<PurchaseProductType> { get }
    var errorSubject: PublishSubject<PurchaseError> { get }
    
    func requestProductInfos()
    func purchase(type: PurchaseProductType)
    func restorePurchase()
}
