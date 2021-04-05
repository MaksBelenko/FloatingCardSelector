//
//  CardFilterItem.swift
//  FloatingCardSelector
//
//  Created by Maksim on 05/04/2021.
//

import UIKit.UIImage

struct CardFilterItem<T: Hashable> {
    let value: T
    let image: UIImage
    let filterName: String
}
