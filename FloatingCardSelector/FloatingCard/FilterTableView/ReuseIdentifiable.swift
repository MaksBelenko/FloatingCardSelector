//
//  ReuseIdentifiable.swift
//  FloatingCardSelector
//
//  Created by Maksim on 05/04/2021.
//

import Foundation

// MARK: - Reuse Identifiable
protocol ReuseIdentifiable {
    static func reuseIdentifier() -> String
}

extension ReuseIdentifiable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
