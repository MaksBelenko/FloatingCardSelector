//
//  CardAnimation.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import Foundation

final class CardAnimation {
    
    private let openAnimation: () -> ()
    private let closeAnimation: () -> ()
    
    init(
        openAnimation: @escaping () -> (),
        closeAnimation: @escaping () -> ()
    ) {
        self.openAnimation = openAnimation
        self.closeAnimation =  closeAnimation
    }
    
    func getAnimation(for nextCardState: CardState) -> (() -> ()) {
        switch nextCardState {
        case .closed:
            return closeAnimation
        case .opened:
            return openAnimation
        }
    }
}
