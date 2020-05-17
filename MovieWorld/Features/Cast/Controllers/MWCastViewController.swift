//
//  MWCastViewController.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/3/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWCastViewController: MWViewController {

    //MARK: - insets variable

    private var edgeInsets = UIEdgeInsets(top: 16, left: .zero, bottom: 10, right: .zero)

    //MARK: - private variable

    private var movieFullCast: [[Personalized]]? = [] {
        didSet {
            self.setUpVisibleOfEmptyListLabel()
            self.tableView.reloadData()
        }
    }

    //MARK:- gui variable

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
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

    private lazy var emptyListLabel = MWEmptyListLabel()

    //MARK: - initialization

    init(cast: MWMovieCastResponse?) {
        super.init()
        self.movieFullCast = cast?.getFullCast()
        self.setUpVisibleOfEmptyListLabel()
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
        self.title = "Cast".local()
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.emptyListLabel)
    }

    // MARK: - constraints

    override func updateViewConstraints() {
        self.tableView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.edgeInsets)
        }

        self.emptyListLabel.snp.updateConstraints { (make) in
            make.center.equalTo(self.tableView.snp.center)
        }
        super.updateViewConstraints()
    }

    //MARK: - setter

    func updateTableView(cast: [[MWMovieCastMember]]) {
        self.movieFullCast = cast
    }

    //MARK: - action if favorites list is empty

    private func setUpVisibleOfEmptyListLabel() {
        guard let cast = self.movieFullCast?.first else {
            self.emptyListLabel.isHidden = false
            return
        }
        self.emptyListLabel.isHidden = !cast.isEmpty
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
        } else {
            let crewMember = self.movieFullCast?[indexPath.section][indexPath.row] as? MWMovieCrewMember
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MWCrewMemberTableViewCell.reuseIdentifier, for: indexPath)
            (cell as? MWCrewMemberTableViewCell)?.set(crewMember: crewMember)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard  let groupMember = self.movieFullCast?[section].first as? MWMovieCrewMember
            else { return UIView() }
        return MWViewForHeader(title: groupMember.job)
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
        return section == 0 ? 0 : 57
    }
}
