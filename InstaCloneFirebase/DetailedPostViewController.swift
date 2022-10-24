//
//  DetailedPostViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 24/10/2022.
//

import UIKit

class DetailedPostViewController: UIViewController {

    @IBOutlet weak var chosenPostIDLabel: UILabel!
    
    var chosenPostID = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenPostIDLabel.text = chosenPostID

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
