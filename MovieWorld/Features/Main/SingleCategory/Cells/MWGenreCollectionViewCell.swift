//
//  MWGenreCollectionViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/20/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWGenreCollectionViewCell: UICollectionViewCell {
    
    var selectedGenre: ((String) -> ())?
    var unselectedGenre: ((String) -> ())?
    private var buttonIsSelected: Bool = false
    
    private lazy var singleGenreButton: MWCustomButton = {
        let button = MWCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.opacity = 0.5
        button.setUpButton(title: "", haveArrow: false)
        button.addTarget(self, action: #selector(singleGenreDidTapped), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(self.singleGenreButton)
        self.singleGenreButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(genre: String) {
        self.singleGenreButton.setUpButton(title: genre, haveArrow: false)
        layoutIfNeeded()
    }
    
    @objc private func singleGenreDidTapped() {
        buttonIsSelected = !buttonIsSelected
        self.singleGenreButton.backgroundColor = buttonIsSelected ? UIColor(named: "accentColor") : UIColor(named: "lightAccentColor")
        
        guard let selectedGenre = self.selectedGenre,
            let titleGenre = self.singleGenreButton.titleLabel?.text,
            let unselectedGenre = self.unselectedGenre
            else { return }
        
        if buttonIsSelected {
            selectedGenre(titleGenre)
        } else {
            unselectedGenre(titleGenre)
        }
    }
}
