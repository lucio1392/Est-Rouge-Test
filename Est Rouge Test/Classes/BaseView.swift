//
//  BaseView.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/4/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol BaseViewProtocol {


}

class BaseView: UIView, BaseViewProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadView()
    }

    internal func loadView() {        
        backgroundColor = .white
    }

}
