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
        view.backgroundColor = .clear
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self._init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _init() {
        view.addSubview(contentView)
        self.makeConstraints()
        self.initController()
    }
    
    func initController() {}
    
    private func makeConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
