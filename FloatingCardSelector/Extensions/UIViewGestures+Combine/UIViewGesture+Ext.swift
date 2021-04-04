//
//  UIViewGesture+Ext.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 27/02/2021.
//

import UIKit.UIView

extension UIView {
    func gesture(_ gestureType: GestureType = .tap()) -> GesturePublisher {
        .init(view: self, gestureType: gestureType)
    }
}
