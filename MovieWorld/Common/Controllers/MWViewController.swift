//
//  MWViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWViewController: UIViewController {

    //MARK:- gui variables

    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    //MARK: - initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        self._init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _init() {
        self.view.addSubview(self.contentView)
        self.makeConstraints()
        self.initController()
    }

    func initController() {}

    // MARK: - constraints

    private func makeConstraints() {
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
        }
    }

    //MARK:- view controller alert

    func errorAlert(message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)

        alert.setValue(NSAttributedString(string: message,
                                          attributes: [NSAttributedString.Key.font:
                                            UIFont.systemFont(ofSize: 17),
                                                       NSAttributedString.Key.foregroundColor:
                                                        UIColor.red]),
                       forKey: "attributedMessage")

        let alertAction = UIAlertAction(title: "OK",
                                        style: .cancel,
                                        handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
