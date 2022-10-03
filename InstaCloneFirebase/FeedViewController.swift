//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 01/10/2022.
//


import UIKit
import Firebase

class FeedViewController: UIViewController {

    @IBOutlet weak var nameText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.text = Auth.auth().currentUser?.email

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
