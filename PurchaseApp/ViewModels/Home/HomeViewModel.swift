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
    struct Context {
        let purchaseService: PurchaseServicing
    }

    let context: Context

    let purchaseStateRelay = BehaviorRelay<PurchaseState>(value: .none)
    var purchaseState: Driver<PurchaseState> { return purchaseStateRelay.asDriver() }
    
    let disposeBag = DisposeBag()

    init(context: Context) {
        self.context = context
        
        context.purchaseService.productsRelay
            .subscribe(onNext: { [weak self] (products) in
                guard let self = self else { return }
                if (products.count > 0) {
                    self.purchaseStateRelay.accept(.none)
                } else {
                    self.purchaseStateRelay.accept(.notSupport)
                }
            })
            .disposed(by: disposeBag)
        
        context.purchaseService.purchaseRelay
            .subscribe(onNext: { [weak self] (type) in
                guard let self = self else { return }
                switch type {
                    case .none:
                        self.purchaseStateRelay.accept(.none)
                        break
                    case .advanced:
                        self.purchaseStateRelay.accept(.advanced)
                        break
                    case .intermediate:
                        self.purchaseStateRelay.accept(.intermediate)
                        break
                }
            })
            .disposed(by: disposeBag)
        
        context.purchaseService.errorSubject
            .subscribe(onNext: { [weak self] (error) in
                guard let self = self else { return }
                self.purchaseStateRelay.accept(.error(error))
            })
            .disposed(by: disposeBag)
    }
    
    func fetchPurchaseItems() {
        context.purchaseService.requestProductInfos()
    }

    func purchaseAdvanced() {
        context.purchaseService.purchase(type: .advanced)
    }
    
    func purchaseIntermediate() {
        context.purchaseService.purchase(type: .intermediate)
    }

    func restore() {
        context.purchaseService.restorePurchase()
    }
}
