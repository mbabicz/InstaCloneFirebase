//
//  DetailedProfileViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 28/10/2022.
//

import UIKit
import Firebase
import SDWebImage

class DetailedProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var chosenUserID = String()
    let firestoreDatabase = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDLabel.text = chosenUserID

        getUserDataFromFirestore()
    }
    
    func getUserDataFromFirestore(){
        let ref = firestoreDatabase.collection("Users").document(chosenUserID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let dataDescription = document.data()
            
            if let username = dataDescription?["username"] as? String{
                self.usernameLabel.text = username
            }

            if let description = dataDescription?["description"] as? String{
                self.descriptionLabel.text = description
            }
            
           if let userImage = dataDescription?["profile picture"] as? String{
                self.profileImage.sd_setImage(with:URL(string: userImage) ,placeholderImage: nil, context: nil)
                self.profileImage.contentMode = .scaleAspectFill
                self.makeRounded(picture: self.profileImage)
            }
            
            //tbc
            self.postsLabel.text = String(1)
            self.followersLabel.text = String(2)
            self.followingLabel.text = String(3)

        }

    }
    
    func makeRounded(picture : UIImageView){
        picture.layer.borderWidth = 1.0
        picture.layer.masksToBounds = false
        picture.layer.borderColor = UIColor.white.cgColor
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
    }


}
