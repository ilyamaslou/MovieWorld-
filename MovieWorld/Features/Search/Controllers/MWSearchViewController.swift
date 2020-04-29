//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
import UIKit
import SnapKit

class MWSearchViewController: MWViewController {

    override func initController() {
        super.initController()

        let view = UIView()
        contentView.addSubview(view)

        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        view.backgroundColor = .yellow
        self.title = "Search"
    }
}
