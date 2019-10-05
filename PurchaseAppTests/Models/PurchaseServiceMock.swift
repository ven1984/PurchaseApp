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
    func purchase(fail: (PurchaseError) -> Void, complete: () -> Void) {
        // TODO: Implement
    }

    func restorePurchase(fail: (PurchaseError) -> Void, complete: () -> Void) {
        // TODO: Implement
    }
}
