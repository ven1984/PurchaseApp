//
//  HomeViewModel.swift
//  PurchaseApp
//
//  Created by Calvin Chang on 2019/10/5.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import RxCocoa
import RxSwift

final class HomeViewModel: HomeViewModeling {
    typealias Context = HasPurchaseService
    
    let context: Context
    
    let purchaseStateRelay = PublishRelay<PurchaseState>()
    var purchaseState: Signal<PurchaseState> { return purchaseStateRelay.asSignal() }
    
    init(context: Context) {
        self.context = context
    }
    
    func purchase() {
        context.purchaseService.purchase(
            fail: { purchaseStateRelay.accept(.error($0)) },
            complete: { purchaseStateRelay.accept(.success) })
    }
    
    func restore() {
        context.purchaseService.restorePurchase(
            fail: { purchaseStateRelay.accept(.error($0)) },
            complete: { purchaseStateRelay.accept(.success) })
    }
    
    
}
