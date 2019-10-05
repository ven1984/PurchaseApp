//
//  PurchaseServicing.swift
//  PurchaseApp
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import Foundation

enum PurchaseError: Error {
    case fail
    case exist
    case timeout
}

protocol PurchaseServicing {

    func purchase(fail: (PurchaseError) -> Void, complete: () -> Void)
    func restorePurchase(fail: (PurchaseError) -> Void, complete: () -> Void)
}

protocol HasPurchaseService {
    var purchaseService: PurchaseServicing { get }
}
