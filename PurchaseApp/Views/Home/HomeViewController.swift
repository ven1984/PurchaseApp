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
        let normal = "Get the premium, experience all the functions!"
        let success = "Thanks for your purchase!"
        let error = "Something wrong, please try again latter"
        let restore = "Already purchase? Restore the purchase"
    }

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var purchaseButton: UIButton!
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
    }

    private func setupUI() {
        purchaseButton.layer.cornerRadius = 15
        purchaseButton.clipsToBounds = true
    
        let range = NSMakeRange(0, textProvider.restore.count)
        let text = NSMutableAttributedString(string: textProvider.restore)
        text.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
        restoreButton.setAttributedTitle(text, for: .normal)
    }

    private func bindViewModel() {
        viewModel.purchaseState.drive(onNext: { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .none:
                self.statusImageView.image = UIImage(named: "premium")
                self.descriptionLabel.text = self.textProvider.normal
            case .error(_):
                // TODO: After purchase state finish, handle the error
                self.statusImageView.image = UIImage(named: "error")
                self.descriptionLabel.text = self.textProvider.error
            case .success:
                self.statusImageView.image = UIImage(named: "success")
                self.descriptionLabel.text = self.textProvider.success
                self.purchaseButton.isHidden = true
                self.restoreButton.isHidden = true
            }
            }).disposed(by: disposeBag)
    }

    @IBAction func purchaseTouchUp(_ sender: Any) {
        viewModel.purchase()
    }

    @IBAction func restoreTouchUp(_ sender: Any) {
        viewModel.restore()
    }
}

