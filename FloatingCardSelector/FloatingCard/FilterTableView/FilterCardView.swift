//
//  FilterCardView.swift
//  FloatingCardSelector
//
//  Created by Maksim on 05/04/2021.
//

import UIKit

protocol FilterItemSelectedDelegate: AnyObject {
    func selectedItem(item: CardFilterItem<AnyHashable>)
}

final class FilterCardView: UIView {
    
    weak var delegate: FilterItemSelectedDelegate?
    
    private let cellHeight: CGFloat = 50
    private let tableView = UITableView()
    private let items: [CardFilterItem<AnyHashable>]
    private let titleText: String
    private var cellReuseIdentifier: String!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // MARK: - Lifecycle
    init(title: String, items: [CardFilterItem<AnyHashable>]) {
        self.items = items
        self.titleText = title
        super.init(frame: .zero)
        
        setupTableView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.separatorStyle = .none
        
        cellReuseIdentifier = CardTableCell.reuseIdentifier()
        tableView.register(CardTableCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func configureUI() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 14,
                          leading: leadingAnchor, paddingLeading: 25)
        
        addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, paddingTop: 12,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterCardView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CardTableCell
        
        let item = items[indexPath.row]
        cell.setText(to: item.filterName)
        cell.setImage(to: item.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = items[indexPath.row]
        delegate?.selectedItem(item: selectedItem)
    }
}
