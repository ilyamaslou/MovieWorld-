//
//  MWGenreCollectionViewCell.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 3/20/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWGenreCollectionViewCell: UICollectionViewCell {

    var selectedGenre: ((String, Bool) -> Void)?
    var buttonIsSelected: Bool = false {
        didSet {
            self.singleGenreButton.backgroundColor = buttonIsSelected ? UIColor(named: "accentColor") : UIColor(named: "lightAccentColor")
        }
    }

    private lazy var singleGenreButton: MWCustomButton = {
        let button = MWCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "lightAccentColor")
        button.setUpButton(title: "", haveArrow: false)
        button.addTarget(self, action: #selector(singleGenreDidTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.singleGenreButton)

        self.singleGenreButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(genreWithSelection: (String, Bool)) {
        self.singleGenreButton.setUpButton(title: genreWithSelection.0, haveArrow: false)
        self.buttonIsSelected = genreWithSelection.1
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }

    @objc private func singleGenreDidTapped() {
        self.buttonIsSelected = !self.buttonIsSelected

        guard let selectedGenre = self.selectedGenre, let titleGenre = self.singleGenreButton.titleLabel?.text
            else { return }
        selectedGenre(titleGenre, self.buttonIsSelected)
    }
}
