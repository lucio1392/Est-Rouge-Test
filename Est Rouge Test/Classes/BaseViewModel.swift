//
//  BaseViewModel.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

protocol BaseViewModelProtocol {

    var disposeBag: DisposeBag { get }

}


class BaseViewModel: BaseViewModelProtocol {

    var disposeBag: DisposeBag = DisposeBag()

}
