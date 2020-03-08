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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var imageWidth = self.imageView?.frame.size.width
        
        //MARK: Fix later
        if imageWidth == 0.0 {
            imageWidth = -4
        }
        
        let titleLabelWidth = self.titleLabel?.frame.size.width
        
        //MARK: FIX
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        titleEdgeInsets = UIEdgeInsets(top: .zero, left: -((imageWidth ?? -4) + 4) , bottom: .zero, right: (imageWidth ?? -4) + 4)
        imageEdgeInsets = UIEdgeInsets(top: .zero, left: titleLabelWidth! , bottom: .zero, right: -titleLabelWidth! - 4)
    }
    
    func setUpButton(title: String = "All", haveArrow: Bool = true) {
        layer.cornerRadius = 5
        backgroundColor = UIColor(named: "accentColor")
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .highlighted)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 13)
        
        //MARK: Fix remake for isHighlighted
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
