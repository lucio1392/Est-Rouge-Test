//
//  UsersView.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class UsersView: BaseView {

    lazy var listUsersTableView: UITableView = {
        let listUsersTableView = UITableView(frame: .zero, style: .plain)
        return listUsersTableView
    }()

    lazy var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    lazy var refreshControll = UIRefreshControl()

    override func loadView() {
        super.loadView()        

        addSubview(listUsersTableView)
        addSubview(loadingIndicator)
        listUsersTableView.addSubview(refreshControll)

        listUsersTableView.snp.makeConstraints(listUsersTableViewLayout())
        loadingIndicator.snp.makeConstraints(loadingIndicatorViewLayout())        

        listUsersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
    }

    fileprivate func listUsersTableViewLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.edges.equalToSuperview()
        }
    }

    fileprivate func loadingIndicatorViewLayout() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.center.equalToSuperview()
        }
    }




}
