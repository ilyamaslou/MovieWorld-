//
//  MWCountryFilterTableViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/23/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCountryFilterTableViewCell: UITableViewCell {
    
    var isCellSelected: Bool = false {
        didSet {
            self.checkImage.isHidden = !self.isCellSelected
        }
    }
    
    private let offsets: UIEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 15)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "selectImage")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUpCell() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.checkImage)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.offsets.top)
            make.left.equalToSuperview().offset(self.offsets.left)
            make.bottom.equalToSuperview().inset(self.offsets.bottom)
        }
        
        self.checkImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.offsets.top)
            make.left.equalTo(self.titleLabel.snp.right)
            make.bottom.equalToSuperview().inset(self.offsets.bottom)
            make.right.equalToSuperview().inset(self.offsets.right)
            
        }
    }
    
    func set(country: (country: String?, isSelected: Bool)) {
        self.titleLabel.text = country.country
        self.isCellSelected = country.isSelected
    }
}
