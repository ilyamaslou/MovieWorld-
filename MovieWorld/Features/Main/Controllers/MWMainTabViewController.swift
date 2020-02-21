//
//  ViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit
import SnapKit

class MWMainTabViewController: MWViewController {

    var singleFilmView: MWContentView { return self.view as! MWContentView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func initController() {
        super.initController()
        let view = MWContentView()
        contentView.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.backgroundColor = .lightGray
        
    }
}

