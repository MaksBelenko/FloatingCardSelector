//
//  FloatingViewController.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import UIKit

final class CardViewController: UIViewController {
    
    private let backgroundOpacity: CGFloat = 0.3
    private let animationDuration: TimeInterval = 0.3
    
    private let cardHeight: CGFloat = 300
    
    private let gestureHandler = GestureHandler()

    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        setupCardAnimations()
        configureUI()
        configureGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performAppearAnimations()
    }
    
    deinit {
        print("Deinit of \(self)")
    }
    
    
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.addSubview(cardView)
        cardView.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, height: cardHeight)
    }
    
    private func setupCardAnimations() {
        let cardMovementAnimation = CardAnimation(openAnimation: { [weak self] in
            guard let self = self else { return }
            self.cardView.frame.origin.y = self.view.frame.height - self.cardHeight
        },
        closeAnimation: { [weak self] in
            guard let self = self else { return }
            self.cardView.frame.origin.y = self.view.frame.height
        })
        
        let backgroundOpacityAnimation = CardAnimation(openAnimation: { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundOpacity)
        },
        closeAnimation: { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        })
        
        gestureHandler.animations.append(cardMovementAnimation)
        gestureHandler.animations.append(backgroundOpacityAnimation)
        
        gestureHandler.onCardClose = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Gestures
    private func configureGestures() {
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        view.addGestureRecognizer(backgroundViewTap)
        
        let panGesture = UIPanGestureRecognizer(target: gestureHandler, action: #selector(GestureHandler.handleCardPan))
        panGesture.delegate = gestureHandler
        cardView.addGestureRecognizer(panGesture)
    }
    
    @objc private func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: animationDuration) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
        
        gestureHandler.animateTransitionIfNeeded(with: .closed, for: 0.5, withDampingRatio: 0.9, completion: nil)
    }
    
    // MARK: - Animations
    func performAppearAnimations() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: animationDuration) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundOpacity)
        }
        
        cardView.frame.origin.y = view.frame.height
        gestureHandler.animateTransitionIfNeeded(with: .opened, for: 0.5, withDampingRatio: 0.9, completion: nil)
    }
}
