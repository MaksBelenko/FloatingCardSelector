//
//  GestureHandler.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import UIKit

final class GestureHandler: NSObject {
    
    private enum PanDirection {
        case Up, Down
    }
    
    var isInteractionsEnabled = true
    
    var onCardClose: (() -> ())?
    var cardHeight: CGFloat = 300
    var animationDuration: TimeInterval = 0.5
    var animationDampingRatio: CGFloat = 0.9
    
    private var animations = [CardAnimation]()
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0
    private var lastProgress: CGFloat = 0
    private let closeProgress: CGFloat = 0.2
    
    
    private var cardVisible = false
    private var cardState: CardState {
        get { return cardVisible ? .opened : .closed }
        set { cardVisible = (newValue == .opened) }
    }
    private var nextCardState: CardState {
        get { return cardVisible ? .closed: .opened }
    }
    
    
    func addAnimation(_ animation: CardAnimation) {
        animations.append(animation)
    }
    
    
    @objc func handleCardPan(recogniser: UIPanGestureRecognizer) {
        if isInteractionsEnabled == false {
            return
        }
        
        switch recogniser.state {
            case .began:
//                let direction = getVerticalPanDirection(for: recogniser)
                startInteractiveTransition(forState: nextCardState, duration: 1)
                print("Began")
            case .changed:
                let translation = recogniser.translation(in: recogniser.view)
                let progress = translation.y / cardHeight
                lastProgress = progress
                updateInteractiveTransition(with: progress)
//                print("Changed \(progress)")
            case .ended:
                print("last progress \(lastProgress)")
                if (lastProgress < closeProgress) {
                    stopAndGoToStartPositionInteractiveTransition()
                } else {
                    continueInteractiveTransition()
                }
                print("Ended")
    
            default:
                break
        }
    }
    
    
    private func getVerticalPanDirection(for recogniser: UIPanGestureRecognizer) -> PanDirection {
        let velocityY = recogniser.velocity(in: recogniser.view).y
        return (velocityY >= 0) ? .Down : .Up
    }
    
    
    func animateTransitionIfNeeded (with state: CardState, duration: TimeInterval? = nil, completion: (() -> ())? = nil) {
        
        let duration = duration ?? animationDuration
        
        animations.forEach { animation in
            let animator = UIViewPropertyAnimator(duration: duration,
                                                  dampingRatio: animationDampingRatio,
                                                  animations: animation.getAnimation(for: state))
            animator.startAnimation()
            runningAnimations.append(animator)
        }
        
        
        runningAnimations.first?.addCompletion { [weak self] _ in
            guard let self = self else { return }
            self.cardVisible = !self.cardVisible
            self.runningAnimations.removeAll()
            completion?()
            
            print("CardVisible = \(self.cardVisible)    LastProgress = \(self.lastProgress)")
            if self.cardVisible == false && self.lastProgress >= self.closeProgress {
                self.onCardClose?()
            }
        }
    }
    
    /**
    Starts an interactive Card transition

    - Parameter state: The card state which is either "Expanded" or "Collapsed".
    - Parameter duration: Duration of the animation.
    */
    private func startInteractiveTransition (forState state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(with: state)
        }

        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    /**
    Updates animators' fraction of the animation that is completed

    - Parameter fractionCompleted: fraction of the animation calculated beforehand.
    */
    private func updateInteractiveTransition (with fractionCompleted: CGFloat) {
       for animator in runningAnimations {
           animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
       }
    }
    
    /**
    Continues all remaining animations
    */
    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    /**
    Stops animation and goes to start of the animation
    */
    private func stopAndGoToStartPositionInteractiveTransition() {
        for animator in runningAnimations {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .current)
        }
        self.runningAnimations.removeAll()
        animateTransitionIfNeeded(with: nextCardState, duration: 0)

    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension GestureHandler: UIGestureRecognizerDelegate  {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {}
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {}
    
    // Enable multiple gesture recognition
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }
}
