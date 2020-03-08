//
//  MWCategoryViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 2/21/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//
import UIKit
import SnapKit

class MWCategoryViewController: MWViewController {
    
    private var categories: [String] = Array(repeating: "Top 250", count: 25)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.categoryCellId)
        return tableView
    }()
    
    override func initController() {
        super.initController()
        
        contentView.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.backgroundColor = .green
        self.title = "Category".local()
    }
    
}

extension MWCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
        withIdentifier: Constants.categoryCellId,
        for: indexPath)
        
        cell.textLabel?.text = self.categories[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
}
