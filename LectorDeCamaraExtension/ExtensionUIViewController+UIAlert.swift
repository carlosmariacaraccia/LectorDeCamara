//
//  ExtensionUIViewController+UIAlert.swift
//  Lector de camara
//
//  Created by Carlos Caraccia on 1/12/21.
//

import Foundation
import UIKit



extension UIViewController {
    
    private func present(_ dismissableAlert:UIAlertController) {
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        dismissableAlert.addAction(dismissAction)
        present(dismissableAlert, animated: true)
    }
    
    func presentAlert(with message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert)
    }
    func present(_ error: Error) {
        presentAlert(with: error.localizedDescription)
    }
    
}

