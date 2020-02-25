//
//  MWMainTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWMainTableViewCell: UITableViewCell {
    
    private lazy var showAllButton = MWCustomButton()
    private lazy var categoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(showAllButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.categoryLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            
        }
        self.showAllButton.snp.updateConstraints { (make) in
            make.top.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func set(categoryName: String) {
        categoryLabel.text = categoryName
        setNeedsUpdateConstraints()
    }
    
}
