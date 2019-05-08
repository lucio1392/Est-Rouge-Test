//
//  Alert.swift
//  Est Rouge Test
//
//  Created by Lucio on 5/6/19.
//  Copyright © 2019 Lucio. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

class Alert {

    static let shared = Alert()

    private init() {}

    private func rootViewController() -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }

    func show(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        Alert.shared.rootViewController().present(alertController, animated: true, completion: nil)
    }
}

