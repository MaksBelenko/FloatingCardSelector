//
//  ViewController.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import UIKit
import Combine

class ExampleViewController: UIViewController {

    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var openCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Click to show card", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(openCardButton)
        openCardButton.centerX(withView: view)
        openCardButton.centerY(withView: view)
        
        openCardButton.tapPublisher
            .sink { [weak self] _ in
                let cardVC = CardViewController()
                cardVC.modalPresentationStyle = .overFullScreen
                self?.present(cardVC, animated: false, completion: nil)
            }
            .store(in: &subscriptions)
    }


}

