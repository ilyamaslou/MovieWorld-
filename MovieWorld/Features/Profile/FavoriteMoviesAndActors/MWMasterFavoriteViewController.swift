//
//  MasterFavoriteViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/15/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWMasterFavoriteViewController: MWViewController {

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

    private lazy var separationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor(named: "shadowColor")?.cgColor
        view.layer.opacity = 0.3
        return view
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
        self.setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.removeBorder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setBorder()
    }

    private func setupView() {
        self.title = "Favorite"
        self.setupSegmentedControl()

        self.contentView.addSubview(self.segmentedControl)
        self.contentView.addSubview(self.separationView)

        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }

        self.separationView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        self.updateView()
    }

    private func setupSegmentedControl() {
        self.segmentedControl.removeAllSegments()
        self.segmentedControl.insertSegment(withTitle: "Films", at: 0, animated: false)
        self.segmentedControl.insertSegment(withTitle: "People", at: 1, animated: false)
        self.segmentedControl.addTarget(self, action: #selector(selectionDidChange), for: .valueChanged)

        self.segmentedControl.selectedSegmentIndex = 0
    }

    private func updateView() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.remove(asChildViewController: self.actorsViewController)
            self.add(asChildViewController: self.moviesViewController)
        } else {
            self.remove(asChildViewController: self.moviesViewController)
            self.add(asChildViewController: self.actorsViewController)
        }
    }

    @objc private func selectionDidChange() {
        self.updateView()
    }
}

extension MWMasterFavoriteViewController {
    private func add(asChildViewController viewController: UIViewController) {
        self.addChild(viewController)

        self.contentView.addSubview(viewController.view)

        viewController.view.snp.remakeConstraints { (make) in
            make.top.equalTo(self.separationView.snp.bottom)
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
