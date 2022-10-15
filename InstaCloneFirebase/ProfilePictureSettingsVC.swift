//
//  ProfilePictureSettingsVC.swift
//  InstaCloneFirebase
//
//  Created by kz on 15/10/2022.
//

import UIKit

class ProfilePictureSettingsVC: UIViewController {

    @IBAction func setUpProfilePicture(_ sender: Any) {
        performSegue(withIdentifier: "toProfileVC", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC"{
            if let destVC = segue.destination as? UITabBarController{
                destVC.selectedIndex = 4
                
            }
        }
    }
    


}
