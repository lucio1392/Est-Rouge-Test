//
//  DetailUT.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import RxSwift
import XCTest
@testable import Est_Rouge_Test

class DetailUserTest: XCTestCase {

    var userDetailViewModel: DetailViewModel!
    var userDetailView: DetailController!

    override func setUp() {
        super.setUp()

        userDetailView = DetailController()
        userDetailViewModel = DetailViewModel(User.user())
        userDetailView.bind(to: userDetailViewModel)

    }

    func test_assert_following() {

        let db = DisposeBag()

        let requestUserExpectation = expectation(description: "Request User Expectation")

        var numberOfFollowing = 0

        userDetailViewModel
            .users
            .drive(onNext: {
                numberOfFollowing = $0.first?.following ?? 0
                requestUserExpectation.fulfill()
            })
            .disposed(by: db)

        wait(for: [requestUserExpectation], timeout: 5.0)

        XCTAssertEqual(numberOfFollowing, Int(detailCell().followingRepoStat.statLabel.text ?? "0"))
    }

    func test_assert_follower() {
        let db = DisposeBag()

        let requestUserExpectation = expectation(description: "Request User Expectation")

        var numberOfFollower = 0

        userDetailViewModel
            .users
            .drive(onNext: {
                numberOfFollower = $0.first?.followers ?? 0
                requestUserExpectation.fulfill()
            })
            .disposed(by: db)

        wait(for: [requestUserExpectation], timeout: 5.0)

        XCTAssertEqual(numberOfFollower, Int(detailCell().followersRepoStat.statLabel.text ?? "0"))
    }

    fileprivate func detailCell() -> DetailCell {
        let detailTableView = userDetailView.rootView.detailUserTableView

        detailTableView.register(DetailCell.self, forCellReuseIdentifier: "DetailUserCell")
        return detailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DetailCell
    }

    override func tearDown() {
        super.tearDown()
        userDetailViewModel = nil
        userDetailView = nil

    }

}
