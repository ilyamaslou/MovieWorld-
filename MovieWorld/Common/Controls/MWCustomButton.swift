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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidth = self.imageView?.frame.size.width
        let titleLabelWidth = self.titleLabel?.frame.size.width
        
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        titleEdgeInsets = UIEdgeInsets(top: .zero, left: -((imageWidth ?? -4) + 4) , bottom: .zero, right: (imageWidth ?? -4) + 4)
        imageEdgeInsets = UIEdgeInsets(top: .zero, left: titleLabelWidth ?? .zero , bottom: .zero, right: -(titleLabelWidth ?? .zero) - 4)
    }
    
    override var isHighlighted: Bool {
        didSet {
            layer.opacity = isHighlighted ? 0.5 : 1
        }
    }
    
    func setUpButton(title: String = "All", haveArrow: Bool = true) {
        layer.cornerRadius = 5
        backgroundColor = UIColor(named: "accentColor")
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .highlighted)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 13)
        
        if haveArrow {
            setImage(UIImage(named: "nextIcon"), for: .normal)
            setImage(UIImage(named: "nextIcon"), for: .highlighted)
        } else {
            setImage(nil, for: .normal)
            setImage(nil, for: .highlighted)
        }
        
        self.setNeedsUpdateConstraints()
    }
    
}
