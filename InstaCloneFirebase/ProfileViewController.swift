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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var username = String()
    var userID = String()
    let firestoreDatabase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser!.uid
        
//        loadUsernameLabel()
//        loadNumberOfPosts()
//        loadNumberOfFollowers()
//        loadNumberOfFollowing()
//        loadDescription()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUsernameLabel()
        loadNumberOfPosts()
        loadNumberOfFollowers()
        loadNumberOfFollowing()
        loadDescription()
    }
    

    @IBAction func profileSettingsButton(_ sender: Any) {
        performSegue(withIdentifier: "toProfileSettings", sender: nil)
    }
    
    func loadUsernameLabel(){
        
        let ref = firestoreDatabase.collection("Users").document(userID)
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
    
    func loadDescription(){
        let ref = firestoreDatabase.collection("Users").document(userID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let dataDescription = document.data()
            var userDescription = dataDescription?["description"] as! String
            self.descriptionLabel.text = userDescription
        }
        
    }
    

}
