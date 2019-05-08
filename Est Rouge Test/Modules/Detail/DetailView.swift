//
//  DetailView.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class DetailView: BaseView {

    lazy var detailUserTableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
    }()

    lazy var refreshControll = UIRefreshControl()

    lazy var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    override func loadView() {
        super.loadView()

        detailUserTableView.separatorStyle = .none

        addSubview(detailUserTableView)
        addSubview(loadingIndicator)
        detailUserTableView.addSubview(refreshControll)

        detailUserTableView.snp.makeConstraints(detailUserTableViewLayout())
        loadingIndicator.snp.makeConstraints(loadingIndicatorViewLayout())


        detailUserTableView.register(DetailCell.self, forCellReuseIdentifier: "DetailUserCell")
    }

    fileprivate func detailUserTableViewLayout() -> (ConstraintMaker) -> Void {
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
