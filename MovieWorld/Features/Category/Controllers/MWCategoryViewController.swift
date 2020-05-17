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

    private var collections: [MWCollectionFromFile] = []
    private var categoryCellId: String = "categoryCellId"

    //MARK:- gui variables

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.categoryCellId)
        return tableView
    }()

    //MARK: - initialization

    override func initController() {
        super.initController()
        self.contentView.addSubview(self.tableView)
        self.title = "Category".local()
        self.loadCategories()
    }

    //MARK: - constraints

    override func updateViewConstraints() {
        self.tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateViewConstraints()
    }

    //MARK: - request

    private func loadCategories() {
        MWNet.sh.collectionsRequest(succesHandler: { [weak self] in
            self?.collections = MWCollectionsHelper.sh.decodeLineByLineFileData(decodeType: MWCollectionFromFile.self)
        })
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MWCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: self.categoryCellId,
            for: indexPath)

        cell.textLabel?.text = self.collections[indexPath.row].name
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MWI.s.pushVC(MWSingleCollectionViewController(collection: self.collections[indexPath.row]))
    }
}
