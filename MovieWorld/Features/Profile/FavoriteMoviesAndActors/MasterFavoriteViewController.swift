//
//  MasterFavoriteViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/15/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MasterFavoriteViewController: MWViewController {
    
    private lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = true
        let titleTextColorAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        view.setTitleTextAttributes(titleTextColorAttributes, for: .selected)
        view.setTitleTextAttributes(titleFontAttributes, for: .normal)
        if #available(iOS 13.0, *) {
            view.selectedSegmentTintColor = UIColor(named: "accentColor")
        }
        return view
    }()
    
    private lazy var sepparationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.backgroundColor = UIColor.white.cgColor
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.5
        label.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        return label
    }()
    
    private lazy var moviesViewController: MWFavoriteMoviesViewController = {
        let viewController = MWFavoriteMoviesViewController()
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var actorsViewController: MWFavoriteActorsViewController = {
        let viewController = MWFavoriteActorsViewController()
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func initController() {
        super.initController()
        setupView()
    }
    
    private func setupView() {
        self.title = "Favorite"
        self.setupSegmentedControl()
        
        self.contentView.addSubview(self.segmentedControl)
        self.contentView.addSubview(self.sepparationLabel)
        
        self.segmentedControl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        self.sepparationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        self.updateView()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Films", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "People", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: actorsViewController)
            add(asChildViewController: moviesViewController)
        } else {
            remove(asChildViewController: moviesViewController)
            add(asChildViewController: actorsViewController)
        }
    }
    
    @objc private func selectionDidChange() {
        updateView()
    }
}

extension MasterFavoriteViewController {
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        
        self.contentView.addSubview(viewController.view)
        
        viewController.view.snp.remakeConstraints { (make) in
            make.top.equalTo(self.sepparationLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        
        viewController.view.removeFromSuperview()
        
        viewController.removeFromParent()
    }
}
