//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 01/10/2022.
//


import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.text = Auth.auth().currentUser?.email
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.likeLabel.text = "0"
        cell.commentLabel.text = " test"
        cell.usernameLabel.text = "test@test.test"
        cell.userImageView.image = UIImage(named: "select.png")
        return cell
    }

}
