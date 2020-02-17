//
//  ViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/17/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWFirstTabViewController: UIViewController {

    var singleFilmView: MWContentView { return self.view as! MWContentView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        self.view = MWContentView()
        view.backgroundColor = .white
    }
}

