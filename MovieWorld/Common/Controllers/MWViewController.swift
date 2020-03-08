//
//  MWViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWViewController: UIViewController {
    
    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self._init()
    }
    
    func initController() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _init() {
        view.addSubview(self.contentView)
        self.makeConstraints()
        self.initController()
    }
    
    private func makeConstraints() {
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)

        }
    }
}
