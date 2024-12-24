//
//  Common.swift
//  DogBreed
//
//  Created by Praveen Kumar on 10/07/24.
//

import Foundation
import UIKit

class Common {
    static func showAlert(title: String?, message: String?, viewController: UIViewController?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}
