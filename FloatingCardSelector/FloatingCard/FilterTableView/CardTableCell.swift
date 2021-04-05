//
//  CardTableCell.swift
//  FloatingCardSelector
//
//  Created by Maksim on 05/04/2021.
//

import UIKit

final class CardTableCell: UITableViewCell, ReuseIdentifiable {    
    
    private let iconSize: CGFloat = 35
    private let selectedCellColour = UIColor(red: 239/256, green: 239/256, blue: 239/256, alpha: 1)
    
    private lazy var icon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        let view = UIView()
        view.backgroundColor = selectedCellColour
        selectedBackgroundView = view
        
        backgroundColor = .clear
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        print("Deinit of cell \(self)")
//    }
    
    
    // MARK: - UI Configuration
    private func configureUI() {
        addSubview(icon)
        icon.centerY(withView: self)
        icon.anchor(leading: leadingAnchor, paddingLeading: 25, width: iconSize, height: iconSize)
        
        addSubview(cellLabel)
        cellLabel.centerY(withView: icon)
        cellLabel.anchor(leading: icon.trailingAnchor, paddingLeading: 13)
    }
    
    // MARK: - Params setup
    func setText(to text: String) {
        cellLabel.text = text
    }
    
    func setImage(to image: UIImage) {
        icon.image = image
    }
}
