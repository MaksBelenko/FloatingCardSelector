//
//  ViewController.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import UIKit
import Combine

enum TestEnum {
    case first
    case second
    case third
}

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
                let filterView = FilterCardView(title: "Select filter option:",
                                                items: [CardFilterItem(value: TestEnum.first, image: #imageLiteral(resourceName: "timeicon-light"), filterName: "first item"),
                                                        CardFilterItem(value: TestEnum.second, image: #imageLiteral(resourceName: "timeicon-light"), filterName: "second item"),
                                                        CardFilterItem(value: TestEnum.third, image: #imageLiteral(resourceName: "timeicon-light"), filterName: "third item")])
                let cardVC = CardViewController(innerView: filterView)
                cardVC.cardHeight = 250
                
                filterView.delegate = self
                
                cardVC.modalPresentationStyle = .overFullScreen
                self?.present(cardVC, animated: false, completion: nil)
            }
            .store(in: &subscriptions)
    }


}

extension ExampleViewController: FilterItemSelectedDelegate {
    func selectedItem(item: CardFilterItem<AnyHashable>) {
        print("Item selected: \(item.value)")
    }
}

