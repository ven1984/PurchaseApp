//
//  HomeViewModelSpec.swift
//  PurchaseAppTests
//
//  Created by Calvin Chang on 2019/10/6.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxSwift

@testable import PurchaseApp

class HomeViewModelSpec: QuickSpec {

    override func spec() {
        var purchaseService: PurchaseServicing!
        var viewModel: HomeViewModeling!
        var disposeBag: DisposeBag!

        describe("HomeViewModelSpec") {
            beforeEach {
                disposeBag = DisposeBag()
            }

            describe("When init") {
                beforeEach {
                    purchaseService = PurchaseServiceMock()
                    viewModel = HomeViewModel(context: .init(purchaseService: purchaseService))
                }
                it("Should have normal state") {
                    var result: PurchaseState?
                    viewModel.purchaseState.drive(onNext: { (state) in
                        result = state
                        }).disposed(by: disposeBag)
                    expect(result) == PurchaseState.none
                }
            }

            describe("When purchase") {
                context("If fail") {
                    beforeEach {
                        purchaseService = PurchaseServiceMock(purchaseState: .error(.fail))
                        viewModel = HomeViewModel(context: .init(purchaseService: purchaseService))
                    }
                    it("Should have error state") {
                        var result: PurchaseState?
                        viewModel.purchaseState.drive(onNext: { (state) in
                            result = state
                            }).disposed(by: disposeBag)

                        viewModel.purchase()
                        expect(result).toEventually(equal(PurchaseState.error(.fail)))
                    }
                }

                context("If success") {
                    beforeEach {
                        purchaseService = PurchaseServiceMock(purchaseState: .success)
                        viewModel = HomeViewModel(context: .init(purchaseService: purchaseService))
                    }
                    it("Should have normal state") {
                        var result: PurchaseState?
                        viewModel.purchaseState.drive(onNext: { (state) in
                            result = state
                            }).disposed(by: disposeBag)
                        viewModel.purchase()
                        expect(result).toEventually(equal(PurchaseState.success))
                    }
                }
            }

            describe("When restore") {
                context("If fail") {
                    beforeEach {
                        purchaseService = PurchaseServiceMock(restoreState: .error(.fail))
                        viewModel = HomeViewModel(context: .init(purchaseService: purchaseService))
                    }
                    it("Should have normal state") {
                        var result: PurchaseState?
                        viewModel.purchaseState.drive(onNext: { (state) in
                            result = state
                            }).disposed(by: disposeBag)
                        viewModel.restore()
                        expect(result).toEventually(equal(PurchaseState.error(.fail)))
                    }
                }

                context("If success") {
                    beforeEach {
                        purchaseService = PurchaseServiceMock(restoreState: .success)
                        viewModel = HomeViewModel(context: .init(purchaseService: purchaseService))
                    }
                    it("Should have normal state") {
                        var result: PurchaseState?
                        viewModel.purchaseState.drive(onNext: { (state) in
                            result = state
                            }).disposed(by: disposeBag)
                        viewModel.restore()
                        expect(result).toEventually(equal(PurchaseState.success))
                    }
                }
            }
        }
    }
}
