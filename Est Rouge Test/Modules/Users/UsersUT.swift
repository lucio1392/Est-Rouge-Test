//
//  UserUT.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import RxSwift
import XCTest
@testable import Est_Rouge_Test

final class UsersTesting: XCTestCase {

    var userViewModel: UsersViewModel!
    var api: API!

    override func setUp() {
        super.setUp()
        api = API.shared
        userViewModel = UsersViewModel()
    }

    func test_equal_amount_of_users() {

        let db = DisposeBag()
        let usersExpectationRequest = expectation(description: "Viewmodel Fetching Users")

        var usersList = [User]()
        var apiUsersList = [User]()

        userViewModel
            .users
            .drive(onNext: { users in
                usersList = users
                usersExpectationRequest.fulfill()
        })
            .disposed(by: db)

        let apiExpectionRequest = expectation(description: "API Fetching Users")

        api
            .listUsers()
            .subscribe(onNext: {
                switch $0 {
                case .failure(let error):
                    XCTAssertNil(error)
                case .success(let value):
                    apiUsersList = value
                }
                apiExpectionRequest.fulfill()
        })
            .disposed(by: db)

        wait(for: [usersExpectationRequest, apiExpectionRequest], timeout: 10.0)

        let compareExpectation = expectation(description: "Compare Expectation")

        XCTAssertEqual(usersList.count, apiUsersList.count)

        compareExpectation.fulfill()

        wait(for: [compareExpectation], timeout: 0.1)
    }

    override func tearDown() {
        super.tearDown()

        userViewModel = nil
        api = nil
    }
}
