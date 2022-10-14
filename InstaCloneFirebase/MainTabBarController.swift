//
//  MainTabBarController.swift
//  InstaCloneFirebase
//
//  Created by kz on 14/10/2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC"{
            print("DZIALA?")
            if let destVC = segue.destination as? UITabBarController{
                destVC.selectedIndex = 4
            }
        }
    }

}
