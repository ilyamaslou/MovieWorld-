//
//  MWCastViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastViewController: MWViewController {

    //MARK: - private variable

    private var movieFullCast: [[Any]]? = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    //MARK:- gui variable

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MWCastMemberTableViewCell.self,
                           forCellReuseIdentifier: MWCastMemberTableViewCell.reuseIdentifier)
        tableView.register(MWCrewMemberTableViewCell.self,
                           forCellReuseIdentifier: MWCrewMemberTableViewCell.reuseIdentifier)

        return tableView
    }()

    //MARK: - initialization

    init(cast: MWMovieCastResponse?) {
        super.init()
        self.movieFullCast = cast?.getFullCast()
    }

    init(castMembers: [[MWMovieCastMember]]) {
        super.init()
        self.movieFullCast = castMembers
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        super.initController()
        self.title = "Cast"
    }

    // MARK: - constraints

    override func updateViewConstraints() {
        self.contentView.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }

        super.updateViewConstraints()
    }

    //MARK: - setter

    func updateTableView(cast: [[MWMovieCastMember]]) {
        self.movieFullCast = cast
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension MWCastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieFullCast?[section].count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movieFullCast?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let castMember = self.movieFullCast?[indexPath.section][indexPath.row] as? MWMovieCastMember {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MWCastMemberTableViewCell.reuseIdentifier, for: indexPath)
            (cell as? MWCastMemberTableViewCell)?.set(castMember: castMember)

            return cell
        } else if let crewMember = self.movieFullCast?[indexPath.section][indexPath.row] as? MWMovieCrewMember {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MWCrewMemberTableViewCell.reuseIdentifier, for: indexPath)
            (cell as? MWCrewMemberTableViewCell)?.set(crewMember: crewMember)

            return cell
        } else {
            fatalError("You have some problems with members of cast")
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard  let groupMember = self.movieFullCast?[section].first as? MWMovieCrewMember
            else { return UIView() }

        let view = UIView()
        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.text = groupMember.job

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }

        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        MWI.s.pushVC(MWMemberViewController(member: self.movieFullCast?[indexPath.section][indexPath.row]))
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 57
        }
    }
}
