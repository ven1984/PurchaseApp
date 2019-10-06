//
//  ViewController.swift
//  PurchaseApp
//
//  Created by Chang Wen-Lung on 04.10.19.
//  Copyright © 2019 Acclegor. All rights reserved.
//

import UIKit
import Swinject
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController {

    struct Text {
        let advanced = "Thanks for your purchase! You're advanced user now."
        let intermediate = "Thanks for your purchase! You're intermediate user now."
        let normal = "Get the advanced or intermediate, experience all the functions!"
        let notSupport = "Does not support in app purchase"
        let error = "Something wrong, please try again latter"
        let restore = "Already purchase? Restore the purchase"
    }

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var advancedButton: UIButton!
    @IBOutlet weak var intermediateButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!

    private let disposeBag = DisposeBag()

    private let viewModel: HomeViewModeling
    private let textProvider = Text()

    private let container = Container() { (c) in
        c.register(PurchaseServicing.self, factory: { _ in PurchaseService()})
        c.register(HomeViewModeling.self, factory: { (r) -> HomeViewModeling in
            return HomeViewModel(context: .init(purchaseService: r.resolve(PurchaseServicing.self)!))
        })
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = container.resolve(HomeViewModeling.self)!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        viewModel = container.resolve(HomeViewModeling.self)!
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchPurchaseItems()
    }

    private func setupUI() {
        advancedButton.layer.cornerRadius = 15
        advancedButton.clipsToBounds = true
        intermediateButton.layer.cornerRadius = 15
        intermediateButton.clipsToBounds = true
    
        let range = NSMakeRange(0, textProvider.restore.count)
        let text = NSMutableAttributedString(string: textProvider.restore)
        text.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
        restoreButton.setAttributedTitle(text, for: .normal)
    }

    private func bindViewModel() {
        viewModel.purchaseState.drive(onNext: { [weak self] (state) in
            guard let self = self else { return }
            switch state {
                case .advanced:
                    self.statusImageView.image = UIImage(named: "success")
                    self.descriptionLabel.text = self.textProvider.advanced
                    self.advancedButton.isHidden = true
                    self.intermediateButton.isHidden = true
                    self.restoreButton.isHidden = true
                    break
                case .intermediate:
                    self.statusImageView.image = UIImage(named: "success")
                    self.descriptionLabel.text = self.textProvider.intermediate
                    self.advancedButton.isHidden = false
                    self.intermediateButton.isHidden = true
                    self.restoreButton.isHidden = true
                    break
                case .none:
                    self.statusImageView.image = UIImage(named: "premium")
                    self.descriptionLabel.text = self.textProvider.normal
                    self.advancedButton.isHidden = false
                    self.intermediateButton.isHidden = false
                    self.restoreButton.isHidden = false
                    break
                case .error(_):
                    // TODO: After purchase state finish, handle the error
                    self.statusImageView.image = UIImage(named: "error")
                    self.descriptionLabel.text = self.textProvider.error
                    break
                case .notSupport:
                    self.statusImageView.image = UIImage(named: "error")
                    self.descriptionLabel.text = self.textProvider.notSupport
                    self.advancedButton.isHidden = true
                    self.intermediateButton.isHidden = true
                    self.restoreButton.isHidden = true
                    break
            }
            }).disposed(by: disposeBag)
    }

    @IBAction func advancedTouchUp(_ sender: Any) {
        viewModel.purchaseAdvanced()
    }

    @IBAction func intermediateButtonTouchUp(_ sender: Any) {
        viewModel.purchaseIntermediate()
    }

    @IBAction func restoreTouchUp(_ sender: Any) {
        viewModel.restore()
    }
}

