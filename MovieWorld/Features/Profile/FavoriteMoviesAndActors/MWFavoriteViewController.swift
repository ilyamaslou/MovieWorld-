//
//  MasterFavoriteViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/15/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWFavoriteViewController: MWViewController {

    //MARK:- gui variables

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
        view.layer.backgroundColor = UIColor(named: "shadowColor")?.cgColor
        view.layer.opacity = 0.3
        return view
    }()

    private lazy var moviesViewController = MWFavoriteMoviesViewController()

    private lazy var actorsViewController = MWFavoriteActorsViewController()

    //MARK: - initialization

    override func initController() {
        super.initController()
        self.title = "Favorites".local()
        self.setupSegmentedControl()
        self.addSubviews()
        self.makeConstraints()
        self.updateView()
    }

    //MARK: - constraints

    private func addSubviews() {
        self.add(self.moviesViewController)
        self.add(self.actorsViewController)
        self.contentView.addSubview(self.segmentedControl)
        self.contentView.addSubview(self.separationView)
    }

    private func makeConstraints() {
        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }

        self.separationView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        self.moviesViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.separationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        self.actorsViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.separationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    //MARK: - viewController life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.removeBorder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setBorder()
    }

    //MARK: - SegmentControl actions

    private func setupSegmentedControl() {
        self.segmentedControl.removeAllSegments()
        self.segmentedControl.insertSegment(withTitle: "Films".local(), at: 0, animated: false)
        self.segmentedControl.insertSegment(withTitle: "People".local(), at: 1, animated: false)
        self.segmentedControl.addTarget(self, action: #selector(self.selectionDidChange), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
    }

    private func updateView() {
        self.actorsViewController.view.isHidden = (self.segmentedControl.selectedSegmentIndex == 0)
            ? true
            : false
    }

    @objc private func selectionDidChange() {
        self.updateView()
    }
}
