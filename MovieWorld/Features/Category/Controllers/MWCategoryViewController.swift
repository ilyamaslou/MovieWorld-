//
//  MWCategoryViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCategoryViewController: MWViewController {

    //MARK: - private variables

    private var categories: [String] = Array(repeating: "Top 250", count: 25)
    private var categoryCellId: String = "categoryCellId"

    //MARK:- gui variables

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.categoryCellId)
        return tableView
    }()

    //MARK: - initialization

    override func initController() {
        super.initController()
        self.title = "Category".local()
        self.loadCategories()
    }

    //MARK: - constraints

    override func updateViewConstraints() {
        self.contentView.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateViewConstraints()
    }

    //MARK: - request

    private func loadCategories() {
        MWNet.sh.collectionsRequest(succesHandler: { [weak self] (isCreated: Bool) in
            if isCreated {
                let decodedArray = MWCollectionOfCategoriesHelper.sh.decodeLineByLineFileData(decodeType: MWCategoriesModel.self)
                print(decodedArray.count)
            }
        })
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MWCategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: self.categoryCellId,
            for: indexPath)

        cell.textLabel?.text = self.categories[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
}
