//
//  FloatingViewController.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import UIKit

final class CardViewController: UIViewController {
    
    var cardHeight: CGFloat = 300 {
        didSet {
            gestureHandler.cardHeight = cardHeight
        }
    }
    
    private let backgroundOpacity: CGFloat = 0.3
    private let animationDuration: TimeInterval = 0.3
    private let gestureHandler = GestureHandler()
    
    private let innerView: CardClosable
    
    private lazy var cardView: CardView = {
        let view = CardView(innerView: innerView)
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    // larger view for grabbing using pan gesture
    private let grabBackgroundHandleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let closeArea: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(innerView: CardClosable) {
        self.innerView = innerView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        innerView.closeCardDelegate = self
        
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
        cardView.anchor(top: view.topAnchor,
                        paddingTop: view.frame.height - cardHeight,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        height: cardHeight)
        
        view.addSubview(closeArea)
        closeArea.anchor(top: view.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: cardView.topAnchor,
                         trailing: view.trailingAnchor)
        
        setupCardHandle()
    }
    
    private func setupCardHandle() {
        // larger view for grabbing using pan gesture
        self.view.addSubview(grabBackgroundHandleView)
        grabBackgroundHandleView.centerX(withView: view)
        grabBackgroundHandleView.anchor(bottom: cardView.topAnchor, width: 100, height: 30)
        
        let handleView = UIView()
        handleView.backgroundColor = .white
        
        grabBackgroundHandleView.addSubview(handleView)
        handleView.centerX(withView: grabBackgroundHandleView)
        handleView.anchor(bottom: grabBackgroundHandleView.bottomAnchor, paddingBottom: 10 ,width: 50, height: 5)
        handleView.layer.cornerRadius = 2.5
    }
    
    
    // MARK: - Animations
    private func setupCardAnimations() {
        let cardMovementAnimation = CardAnimation(openAnimation: { [weak self] in
            guard let self = self else { return }
            self.cardView.frame.origin.y = self.view.frame.height - self.cardHeight
        },
        closeAnimation: { [weak self] in
            guard let self = self else { return }
            self.cardView.frame.origin.y = self.view.frame.height
        })

        let handleCardMovementAnimation = CardAnimation(openAnimation: { [weak self] in
            guard let self = self else { return }
            self.grabBackgroundHandleView.frame.origin.y = self.view.frame.height - self.cardHeight - self.grabBackgroundHandleView.frame.height
        },
        closeAnimation: { [weak self] in
            guard let self = self else { return }
            self.grabBackgroundHandleView.frame.origin.y = self.view.frame.height - self.grabBackgroundHandleView.frame.height
        })
        
        let backgroundOpacityAnimation = CardAnimation(openAnimation: { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundOpacity)
        },
        closeAnimation: { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        })
        
        gestureHandler.addAnimation(cardMovementAnimation)
        gestureHandler.addAnimation(handleCardMovementAnimation)
        gestureHandler.addAnimation(backgroundOpacityAnimation)
        
        gestureHandler.onCardClose = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Gestures
    private func configureGestures() {
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        closeArea.addGestureRecognizer(backgroundViewTap)
//        backgroundViewTap.cancelsTouchesInView = false
        
        let cardPan = setPanGestureRecognizer()
        cardView.addGestureRecognizer(cardPan)
        grabBackgroundHandleView.addGestureRecognizer(setPanGestureRecognizer())
        cardPan.cancelsTouchesInView = false
    }
    
    private func setPanGestureRecognizer() -> UIPanGestureRecognizer {
        let panGesture = UIPanGestureRecognizer(target: gestureHandler, action: #selector(GestureHandler.handleCardPan))
        panGesture.delegate = gestureHandler

        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 4
        return panGesture
    }
    
    @objc private func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        forceCloseCard()
    }
    
    // MARK: - Animations
    private func performAppearAnimations() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: animationDuration) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundOpacity)
        }
        
        // start position
        cardView.frame.origin.y = view.frame.height
        grabBackgroundHandleView.frame.origin.y = view.frame.height - grabBackgroundHandleView.frame.height
        
        forceOpenCard()
    }
    
    // MARK: - Force card actions
    private func forceOpenCard() {
        gestureHandler.isInteractionsEnabled = false
        gestureHandler.animateTransitionIfNeeded(with: .opened) { [gestureHandler] in
            gestureHandler.isInteractionsEnabled = true
        }
    }
    
    private func forceCloseCard() {
        gestureHandler.isInteractionsEnabled = false
        gestureHandler.animateTransitionIfNeeded(with: .closed) { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: - CloseCardDelegate
extension CardViewController: CardCloseDelegate {
    func closeCard() {
        forceCloseCard()
    }
}
