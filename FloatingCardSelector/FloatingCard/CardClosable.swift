//
//  CloseCardDelegate.swift
//  FloatingCardSelector
//
//  Created by Maksim on 05/04/2021.
//

import UIKit.UIView

protocol CardCloseDelegate: AnyObject {
    func closeCard()
}
 
protocol CardClosable: UIView {
    var closeCardDelegate: CardCloseDelegate? { get set }
}
