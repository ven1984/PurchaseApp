//
//  PurchaseServiceMock.swift
//  PurchaseAppTests
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import Foundation

@testable import PurchaseApp

final class PurchaseServiceMock: PurchaseServicing {

    let purchaseState: PurchaseState
    let restoreState: PurchaseState

    init(purchaseState: PurchaseState = .none, restoreState: PurchaseState = .none) {
        self.purchaseState = purchaseState
        self.restoreState = restoreState
    }

    func purchase(fail: (PurchaseError) -> Void, complete: () -> Void) {
        switch purchaseState {
        case .error(let error):
            fail(error)
        case .success:
            complete()
        default: break
        }
    }

    func restorePurchase(fail: (PurchaseError) -> Void, complete: () -> Void) {
        switch restoreState {
        case .error(let error):
            fail(error)
        case .success:
            complete()
        default: break
        }
    }
}
