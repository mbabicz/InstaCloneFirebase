//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 01/10/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)

            } catch{
                print("error")
            }
    }

}
