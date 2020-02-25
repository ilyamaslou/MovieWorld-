//
//  MWCustomButton.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/25/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCustomButton: UIButton {
     
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.setUpButton()
        self.addTarget(self, action: #selector(buttonDidTapped), for: .touchDown)
        self.addTarget(self, action: #selector(buttonDidUntapped), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpButton()
    }
    
    func setUpButton(title: String = "All", haveArrow: Bool = true) {
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        
        //MARK: This line is temp solution!!!
        semanticContentAttribute = .forceRightToLeft
        
        layer.cornerRadius = 5
        backgroundColor = UIColor(named: "accentColor")
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .highlighted)

        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 13)
        
        if haveArrow {
            setImage(UIImage(named: "nextIcon"), for: .normal)
            setImage(UIImage(named: "nextIcon"), for: .highlighted)
        }
        
        self.layoutIfNeeded()
    }
    
    @objc private func buttonDidTapped() {
        layer.opacity = 0.5
    }
    
    @objc private func buttonDidUntapped() {
        layer.opacity = 1
    }
}
