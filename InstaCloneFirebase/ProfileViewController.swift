//
//  ProfileViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 10/10/2022.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsernameLabel()
        loadNumberOfPosts()
        loadNumberOfFollowers()
        loadNumberOfFollowing()
    }
    
    func loadUsernameLabel(){
        let userID = Auth.auth().currentUser!.uid
        let ref = Firestore.firestore().collection("Users").document(userID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let dataDescription = document.data()
            self.username = dataDescription?["username"] as! String
            self.usernameLabel.text = self.username
        }
    }
    
    func loadNumberOfPosts(){
        
        
        self.postsLabel.text = String(1)
    }
    
    func loadNumberOfFollowers(){
        
        self.followersLabel.text = String(2)
    }
    
    func loadNumberOfFollowing(){
        
        self.followingLabel.text = String(3)
    }
    

}
