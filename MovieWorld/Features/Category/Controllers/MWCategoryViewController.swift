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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCellId")
    }
    
    private lazy var tableView = UITableView()
    
    override func initController() {
        super.initController()
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.backgroundColor = .green
        self.title = "Category"
    }
    
}

extension MWCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
        withIdentifier: "categoryCellId",
        for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
