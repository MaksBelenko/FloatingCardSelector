//
//  CardView.swift
//  FloatingCardSelector
//
//  Created by Maksim on 04/04/2021.
//

import UIKit

final class CardView: UIView {
    
    private let innerView: UIView
    
    init(innerView: UIView) {
        self.innerView = innerView
        super.init(frame: .zero)
        
        clipsToBounds = true
        
        addSubview(innerView)
        innerView.contain(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


