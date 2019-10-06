//
//  PurchaseService.swift
//  PurchaseApp
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import Foundation
import StoreKit
import RxCocoa
import RxSwift

final class PurchaseService: NSObject, PurchaseServicing, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    fileprivate var productIDs: Array<String> = []
    let productsRelay = BehaviorRelay<[SKProduct]>(value: [])
    var purchaseRelay = BehaviorRelay<PurchaseProductType>(value: .none)
    var errorSubject = PublishSubject<PurchaseError>()
    
    override init() {
        super.init()
        productIDs.append("item_id_from_apple_01")
        productIDs.append("item_id_from_apple_02")
        
        SKPaymentQueue.default().add(self)
    }
    
    func requestProductInfos() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
    
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("RequestProductInfos failed")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            var products:[SKProduct] = []
            for product in response.products {
                products.append(product)
            }
            print(products)
            productsRelay.accept(products)
        } else {
            productsRelay.accept([])
            print("No products available now")
        }
    }
    
    func purchase(type: PurchaseProductType) {
        guard let product = typeForProduct(type) else {
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func typeForProduct(_ type: PurchaseProductType) -> SKProduct? {
        guard productsRelay.value.count > 1 else {
            return nil
        }
        
        switch type {
            case .advanced:
                return productsRelay.value[0]
            case .intermediate:
                return productsRelay.value[1]
            default:
                return nil
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                SKPaymentQueue.default().finishTransaction(transaction)
                completeTransaction(transaction)
            } else if transaction.transactionState == .failed {
                SKPaymentQueue.default().finishTransaction(transaction)
                errorSubject.onNext(.fail)
            } else if transaction.transactionState == .restored {
                SKPaymentQueue.default().finishTransaction(transaction)
                completeTransaction(transaction)
            }
        }
    }
    
    func completeTransaction(_ transaction: SKPaymentTransaction) {
        if transaction.payment == productsRelay.value[0] {
            purchaseRelay.accept(.advanced)
        } else if transaction.payment == productsRelay.value[1] {
            purchaseRelay.accept(.intermediate)
        }
    }

    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("restore completed transcation finish")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("restore completed transcation failed")
    }
}
